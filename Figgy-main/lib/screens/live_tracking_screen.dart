import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:figgy_app/theme/app_theme.dart';

// ─────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────
class Ride {
  final String pickupName;
  final double pickupLat;
  final double pickupLng;
  final String dropName;
  final double dropLat;
  final double dropLng;
  String status; // assigned | picked_up | on_the_way | delivered
  final DateTime startTime;
  DateTime? endTime;
  final double distance;
  final int earnings;

  Ride({
    required this.pickupName,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropName,
    required this.dropLat,
    required this.dropLng,
    required this.status,
    required this.startTime,
    required this.distance,
    required this.earnings,
    this.endTime,
  });

  LatLng get pickupLatLng => LatLng(pickupLat, pickupLng);
  LatLng get dropLatLng => LatLng(dropLat, dropLng);
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────
  Ride? currentRide;
  List<Ride> completedRides = [];
  List<LatLng> routeCoordinates = [];
  LatLng riderPosition = const LatLng(13.0418, 80.2341);

  // ── Animation & Simulation ─────────────────
  Timer? _stepTimer;
  int _routeIndex = 0;
  int _subStep = 0;
  static const int _subSteps = 25; // Interpolation steps per segment
  static const Duration _stepDuration = Duration(milliseconds: 80);

  // ── Map Controller ─────────────────────────
  final MapController _mapController = MapController();

  // ── Chennai Locations ──────────────────────
  static const List<Map<String, dynamic>> _locations = [
    {'name': 'T Nagar',     'lat': 13.0418, 'lng': 80.2341},
    {'name': 'Anna Nagar',  'lat': 13.0850, 'lng': 80.2101},
    {'name': 'Velachery',   'lat': 12.9791, 'lng': 80.2241},
    {'name': 'Adyar',       'lat': 13.0067, 'lng': 80.2578},
    {'name': 'Kodambakkam', 'lat': 13.0524, 'lng': 80.2237},
    {'name': 'Mylapore',    'lat': 13.0339, 'lng': 80.2696},
    {'name': 'Nungambakkam','lat': 13.0605, 'lng': 80.2449},
  ];

  @override
  void initState() {
    super.initState();
    _startNewRide();
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  // ── Route Generation ───────────────────────
  /// Generates intermediate LatLng points along a straight path between two coords.
  List<LatLng> _generateRoute(LatLng from, LatLng to) {
    const int segments = 12;
    final List<LatLng> points = [from];
    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      // Add slight curve via a mid-point offset for realism
      final midLat = from.latitude + (to.latitude - from.latitude) * t +
          (i < segments ~/ 2 ? 0.002 : -0.001);
      final midLng = from.longitude + (to.longitude - from.longitude) * t;
      points.add(LatLng(midLat, midLng));
    }
    points.add(to);
    return points;
  }

  // ── Ride Generator ─────────────────────────
  Ride _generateMockRide() {
    final rng = Random();
    final pickup = _locations[rng.nextInt(_locations.length)];
    Map<String, dynamic> drop;
    do {
      drop = _locations[rng.nextInt(_locations.length)];
    } while (drop['name'] == pickup['name']);

    final dist = (rng.nextDouble() * 8 + 2).roundToDouble();
    final earn = rng.nextInt(151) + 50;

    return Ride(
      pickupName: pickup['name'],
      pickupLat: pickup['lat'],
      pickupLng: pickup['lng'],
      dropName: drop['name'],
      dropLat: drop['lat'],
      dropLng: drop['lng'],
      status: 'assigned',
      startTime: DateTime.now(),
      distance: dist,
      earnings: earn,
    );
  }

  // ── Start New Ride ─────────────────────────
  void _startNewRide() {
    final ride = _generateMockRide();
    final route = _generateRoute(ride.pickupLatLng, ride.dropLatLng);

    setState(() {
      currentRide = ride;
      routeCoordinates = route;
      riderPosition = route.first;
      _routeIndex = 0;
      _subStep = 0;
    });

    // Move map to pickup
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _mapController.move(ride.pickupLatLng, 13.5);
    });

    // Brief pause at pickup (simulate order acceptance)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => currentRide?.status = 'picked_up');
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => currentRide?.status = 'on_the_way');
        _beginMovement();
      });
    });
  }

  // ── Smooth Movement ────────────────────────
  void _beginMovement() {
    _stepTimer?.cancel();
    _stepTimer = Timer.periodic(_stepDuration, (_) => _tick());
  }

  void _tick() {
    if (!mounted || currentRide == null) return;

    final route = routeCoordinates;
    if (_routeIndex >= route.length - 1) {
      // Reached destination
      _stepTimer?.cancel();
      setState(() {
        riderPosition = route.last;
        currentRide!.status = 'delivered';
        currentRide!.endTime = DateTime.now();
        completedRides.insert(0, currentRide!);
        currentRide = null;
      });

      // After 5 seconds, start a new ride
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) _startNewRide();
      });
      return;
    }

    final from = route[_routeIndex];
    final to = route[_routeIndex + 1];

    // Linear interpolation (lerp) between two route points
    final t = _subStep / _subSteps;
    final lat = from.latitude + (to.latitude - from.latitude) * t;
    final lng = from.longitude + (to.longitude - from.longitude) * t;

    setState(() {
      riderPosition = LatLng(lat, lng);
    });

    // Pan map slightly to follow rider
    _mapController.move(riderPosition, 14.0);

    _subStep++;
    if (_subStep >= _subSteps) {
      _subStep = 0;
      _routeIndex++;
    }
  }

  // ── Status Label ────────────────────────────
  String _statusLabel(String s) {
    switch (s) {
      case 'assigned':  return 'Order Assigned';
      case 'picked_up': return 'Picked Up';
      case 'on_the_way':return 'On The Way';
      case 'delivered': return 'Delivered';
      default:          return s;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'assigned':  return Colors.blue;
      case 'picked_up': return AppColors.warning;
      case 'on_the_way':return AppColors.brandPrimary;
      case 'delivered': return AppColors.success;
      default:          return AppColors.textMuted;
    }
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('logo.png'),
          ),
        ),
        title: Text(
          'LIVE TRACKING',
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.brandPrimary.withOpacity(0.1),
              radius: 18,
              child: const Icon(Icons.person_outline_rounded,
                  color: AppColors.brandPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Live Status Banner ─────────────────────
            _buildStatusBanner(),

            // ── LIVE MAP ────────────────────────────────
            _buildLiveMap(),

            // ── Current Delivery Card ──────────────────
            if (currentRide != null) _buildCurrentDeliveryCard(),

            const SizedBox(height: 16),

            // ── Completed Deliveries (BELOW MAP) ────────
            _buildCompletedDeliveriesSection(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ── Status Banner ──────────────────────────
  Widget _buildStatusBanner() {
    final status = currentRide?.status ?? 'waiting';
    final label = currentRide != null ? _statusLabel(status) : 'Awaiting Next Order...';
    final color = currentRide != null ? _statusColor(status) : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
                color: color, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          if (currentRide != null)
            Text(
              '${currentRide!.pickupName} → ${currentRide!.dropName}',
              style: AppTypography.small.copyWith(color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }

  // ── Live Map ────────────────────────────────
  Widget _buildLiveMap() {
    return Container(
      height: 280,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: riderPosition,
            initialZoom: 13.5,
          ),
          children: [
            // Base Map
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.figgy.app',
            ),

            // Route Polyline
            if (routeCoordinates.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routeCoordinates,
                    strokeWidth: 4.0,
                    color: AppColors.brandPrimary.withOpacity(0.7),
                  ),
                ],
              ),

            // Markers
            MarkerLayer(
              markers: [
                // Pickup
                if (currentRide != null)
                  Marker(
                    point: currentRide!.pickupLatLng,
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.radio_button_checked_rounded,
                        color: Colors.green, size: 28),
                  ),

                // Drop
                if (currentRide != null)
                  Marker(
                    point: currentRide!.dropLatLng,
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.location_on_rounded,
                        color: AppColors.error, size: 32),
                  ),

                // Rider (Animated position)
                Marker(
                  point: riderPosition,
                  width: 44,
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.brandPrimary.withOpacity(0.4),
                            blurRadius: 10)
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.delivery_dining_rounded,
                        color: AppColors.brandPrimary, size: 22),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Current Delivery Card ──────────────────
  Widget _buildCurrentDeliveryCard() {
    final ride = currentRide!;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_rounded,
                  color: AppColors.brandPrimary, size: 20),
              const SizedBox(width: 8),
              Text('Current Delivery',
                  style: AppTypography.bodyMedium
                      .copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(ride.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(ride.status),
                  style: AppTypography.small.copyWith(
                      color: _statusColor(ride.status),
                      fontWeight: FontWeight.w800,
                      fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PICKUP',
                        style: AppTypography.small
                            .copyWith(color: AppColors.textMuted, fontSize: 10)),
                    Text(ride.pickupName,
                        style: AppTypography.bodyMedium
                            .copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.textMuted, size: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('DROP',
                        style: AppTypography.small
                            .copyWith(color: AppColors.textMuted, fontSize: 10)),
                    Text(ride.dropName,
                        style: AppTypography.bodyMedium
                            .copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(Icons.route_rounded, '${ride.distance.toStringAsFixed(1)} km'),
              _buildInfoChip(Icons.currency_rupee_rounded, '₹${ride.earnings}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brandPrimary, size: 16),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.bodySmall
                .copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }

  // ── Completed Deliveries (BELOW MAP) ────────
  Widget _buildCompletedDeliveriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Completed Deliveries',
                  style: AppTypography.h3
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              if (completedRides.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${completedRides.length} rides',
                    style: AppTypography.small.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (completedRides.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(Icons.history_rounded,
                      color: AppColors.textMuted.withOpacity(0.4), size: 40),
                  const SizedBox(height: 12),
                  Text('No deliveries completed yet',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completedRides.length,
              itemBuilder: (context, index) {
                final ride = completedRides[index];
                final duration =
                    ride.endTime!.difference(ride.startTime).inMinutes;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_circle_rounded,
                              color: AppColors.success, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ride.pickupName} → ${ride.dropName}',
                                style: AppTypography.bodySmall.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${ride.distance.toStringAsFixed(1)} km  •  ₹${ride.earnings}  •  $duration mins',
                                style: AppTypography.small.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Delivered',
                            style: AppTypography.small.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w800,
                                fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

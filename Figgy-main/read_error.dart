import 'dart:io';
void main() {
  var file = File('build_error.txt');
  var contents = file.readAsStringSync();
  print(contents.substring(0, contents.length > 5000 ? 5000 : contents.length));
}

import os
import subprocess

result = subprocess.run(['dart', 'analyze', 'lib'], capture_output=True, text=True)
with open('py_analyze.txt', 'w', encoding='utf-8') as f:
    f.write(result.stdout)
    f.write(result.stderr)
print("Done")

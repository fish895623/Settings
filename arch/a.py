#!/usr/bin/python3
import subprocess
import re

popen = subprocess.Popen(
    "ls -a", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True
)
(stdoutdata, stderrdata) = popen.communicate()

for i in stdoutdata.decode('utf-8').split('\n'):
    if re.search("py", i):
        print(i)
    else:
        pass

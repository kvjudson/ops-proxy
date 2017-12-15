import os
import sys
import json
import signal

from subprocess import Popen

proc = None
killed = False

def exit_gracefully(sig, frame):
  killed = True
  if proc is not None:
    os.kill(proc.pid, signal.SIGTERM)

def execute(args):
  if not killed:
    print("Executing: " + str(args))
    proc = Popen(args, shell=True)
    proc.wait()

if __name__ == '__main__':
  signal.signal(signal.SIGINT, exit_gracefully)
  signal.signal(signal.SIGTERM, exit_gracefully)

  config = json.load(open(sys.argv[1]))
  for item in config:
    execute(item)
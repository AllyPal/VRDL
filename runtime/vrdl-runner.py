#!/bin/python3
# Modified from script provided by noframelimit

import subprocess
import time
import os
import threading

WINE_PREFIX="/opt/vrdl/prefix"

servers = [
    r'"/opt/vrdl/game/default/System/Dedicated_Server.exe" -dedicated -profile Test-1 -hide3d -query_port 7776 -game_port 8888 -map_playlist Standard -ticks 100',
]

def launch_and_monitor(cmd):
    while True:
        print(f"Starting: {cmd}")
        proc = subprocess.Popen(f"WINEPREFIX={WINE_PREFIX} WINEDEBUG=-all wine {cmd}", shell=True)
        proc.wait()
        print(f"Process exited, restarting: {cmd}")
        time.sleep(10)

threads = []

for i, server_cmd in enumerate(servers):
    t = threading.Thread(target=launch_and_monitor, args=(server_cmd,))
    t.daemon = True
    t.start()
    threads.append(t)
    time.sleep(10)

try:
    while True:
        time.sleep(60)
except KeyboardInterrupt:
    print("Exiting main process.")

#!/system/bin/sh
# Bring-up diagnostics: keep a copy of the kernel log, Android log and mount state in /cache
# so a failed boot can be read afterwards from the recovery. Remove once the system is stable.
D=/cache/bootlog
mkdir -p $D
n=0
while [ $n -lt 600 ]; do
    /system/bin/dmesg > $D/dmesg.txt 2>&1
    /system/bin/logcat -d -v threadtime > $D/logcat.txt 2>&1
    /system/bin/mount > $D/mounts.txt 2>&1
    /system/bin/ls -la /data > $D/data-ls.txt 2>&1
    /system/bin/getprop > $D/props.txt 2>&1
    echo "n=$n $(/system/bin/date)" > $D/heartbeat.txt
    sync
    n=$((n+1))
    /system/bin/sleep 2
done

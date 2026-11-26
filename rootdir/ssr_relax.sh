#!/system/bin/sh
# Make a crash of the Wi-Fi/BT (wcnss) or other subsystem restart only that subsystem
# instead of resetting the whole SoC (kernel default restart_level=SYSTEM).
for d in /sys/bus/msm_subsys/devices/subsys*; do
    [ -w $d/restart_level ] && echo related > $d/restart_level
done

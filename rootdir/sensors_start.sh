#!/system/bin/sh
# The MSM8226 sensors (LSM303D accel/mag, AL3320B ALS) live behind the ADSP: boot it, wait for it, then start the daemon.
echo 1 > /sys/kernel/boot_adsp/boot
i=0
while [ $i -lt 30 ]; do
  [ "$(cat /sys/bus/msm_subsys/devices/subsys0/state)" = "ONLINE" ] && break
  sleep 1
  i=$((i+1))
done
setprop ctl.start sensors

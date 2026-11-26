#!/system/bin/sh
# Bring the Pronto/BP (WCNSS) radio up after wpa_supplicant has attached.
#
# This device has no userspace wifi HAL (hardware/qcom/wlan qcwcn is not built
# for it); the stock behaviour of powering the firmware is normally done by
# wifi.msm8226.so's toggleDriverState(). Replicate the two things it does:
#   1. open()/close() /dev/wcnss_wlan, which trips hdd's wcnss_wlan_thread into
#      booting the WCNSS firmware (the node's read/write contents are ignored;
#      the open itself is the command);
#   2. set IFF_UP on wlan0 (prima does not auto-up, and a down interface makes
#      every scan return nothing while the UI still says Wi-Fi is on).
#
# Run as a oneshot from an `on property:init.svc.wpa_supplicant=running` trigger;
# sleep covers supplicant attach timing. Also seeds the prima config the driver
# parses at insmod: /data/misc/wifi/WCNSS_qcom_cfg.ini (stock shipped that file
# via factory userdata; the /system/etc/firmware symlink chain expects it there).

sleep 4

if [ ! -f /data/misc/wifi/WCNSS_qcom_cfg.ini ]; then
    mkdir /data/misc/wifi 2>/dev/null
    cp /system/etc/wifi/WCNSS_qcom_cfg.ini /data/misc/wifi/WCNSS_qcom_cfg.ini
    chown 1000 1010 /data/misc/wifi/WCNSS_qcom_cfg.ini
    chmod 0660 /data/misc/wifi/WCNSS_qcom_cfg.ini
fi

exec 9<> /dev/wcnss_wlan
exec 9<&-

# wlan0 only registers once the firmware handshake (hdd_open) completed.
for i in 1 2 3 4 5; do
    [ -e /sys/class/net/wlan0 ] && break
    sleep 2
done
/system/bin/ip link set wlan0 up

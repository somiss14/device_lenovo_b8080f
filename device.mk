LOCAL_PATH := device/lenovo/b8080f

# Proprietary blobs extracted from the tablet's own stock system (see setup scripts)
$(call inherit-product, vendor/lenovo/b8080f/b8080f-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# 10" tablet, 240 dpi, 2 GB RAM
PRODUCT_AAPT_CONFIG := normal large xlarge
PRODUCT_AAPT_PREF_CONFIG := hdpi
TARGET_SCREEN_WIDTH := 1920
TARGET_SCREEN_HEIGHT := 1200
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# Permissions / features
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

# Ramdisk: startup scripts and filesystem table
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.qcom:root/fstab.qcom \
    $(LOCAL_PATH)/rootdir/init.qcom.rc:root/init.qcom.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.usb.rc:root/init.qcom.usb.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.usb.sh:root/init.qcom.usb.sh \
    $(LOCAL_PATH)/rootdir/ueventd.qcom.rc:root/ueventd.qcom.rc \
    $(LOCAL_PATH)/rootdir/bootlog.sh:root/bootlog.sh \
    $(LOCAL_PATH)/rootdir/adb_keys:root/adb_keys \
    $(LOCAL_PATH)/rootdir/ssr_relax.sh:root/ssr_relax.sh \
    $(LOCAL_PATH)/rootdir/insmod_legacy:root/insmod_legacy \
    $(LOCAL_PATH)/rootdir/sensors_start.sh:root/sensors_start.sh \
    $(LOCAL_PATH)/rootdir/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/rootdir/mixer_paths.xml:system/etc/mixer_paths.xml \
    $(LOCAL_PATH)/rootdir/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/rootdir/wifipower.sh:system/etc/wifi/wifipower.sh \
    $(LOCAL_PATH)/rootdir/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/rootdir/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

# Graphics / display (built from source; Adreno blobs come from stock)
PRODUCT_PACKAGES += \
    libqpc \
    gralloc.msm8226 \
    hwcomposer.msm8226 \
    copybit.msm8226 \
    memtrack.msm8226 \
    lights.msm8226 \
    libqdMetaData \
    libqdutils \
    libtinyxml

# Audio
PRODUCT_PACKAGES += \
    audio.primary.msm8226 \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    libaudio-resampler \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    tinymix

# Media codecs
PRODUCT_COPY_FILES += \
    device/lenovo/b8080f/media_codecs.xml:system/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml
# libOmxVdec deliberately NOT built from media-caf: its capability probes use a
# newer venus/V4L2 ABI than this 3.4 kernel; allocateNode fails and MediaCodecList
# silently drops every qcom video decoder (software decode only). The stock KK
# blob copied by b8080f-vendor.mk to /system/vendor/lib is used instead; it opens
# the legacy /dev/video/venus_dec node name (symlinked in init.qcom.rc).
PRODUCT_PACKAGES += \
    libOmxCore \
    libOmxVenc \
    libstagefrighthw

# Wi-Fi
PRODUCT_PACKAGES += \
    wcnss_service \
    hostapd \
    hostapd_default.conf \
    wpa_supplicant \
    wpa_supplicant.conf \
    p2p_supplicant_overlay.conf \
    wpa_supplicant_overlay.conf \
    libwpa_client

# Bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor

# Power (generic HAL)
PRODUCT_PACKAGES += \
    power.default

# Filesystem tools / USB accessory
PRODUCT_PACKAGES += \
    e2fsck_static \
    resize2fs_static \
    make_ext4fs \
    setup_fs \
    com.android.future.usb.accessory

# The Saffron & Olive / RPOS point-of-sale app is added by a separate include
# (see README) once the base system boots.
-include device/lenovo/b8080f/pos.mk

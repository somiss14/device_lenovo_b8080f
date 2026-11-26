DEVICE_PATH := device/lenovo/b8080f
-include vendor/lenovo/b8080f/BoardConfigVendor.mk

# Platform
TARGET_BOARD_PLATFORM := msm8226
TARGET_BOARD_PLATFORM_GPU := qcom-adreno305
TARGET_BOOTLOADER_BOARD_NAME := MSM8226
TARGET_NO_BOOTLOADER := true
BOARD_USES_QCOM_HARDWARE := true

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_SMP := true
TARGET_CPU_MEMCPY_BASE_OPT_DISABLE := true

# Kernel: Lenovo's stock 3.4.0 kernel + device tree, taken from the tablet's own boot.img
# (its /system/lib/modules/*.ko were built for exactly this kernel).
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/kernel
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 2048
# androidboot.selinux=permissive during bring-up only; tighten once it boots.
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 androidboot.selinux=permissive
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --dt $(DEVICE_PATH)/dt.img

# Partitions (from the tablet's GPT)
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1610612736
BOARD_CACHEIMAGE_PARTITION_SIZE := 134217728
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12949896704
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072
TARGET_USERIMAGES_USE_EXT4 := true

# Graphics (Adreno 305)
USE_OPENGL_RENDERER := true
TARGET_USES_ION := true
TARGET_USES_C2D_COMPOSITION := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_CONTINUOUS_SPLASH_ENABLED := false
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# Audio
BOARD_USES_ALSA_AUDIO := true

# Bluetooth (Qualcomm WCN36xx over SMD)
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Wi-Fi (Qualcomm Pronto, prima driver as an external module)
BOARD_HAS_QCOM_WLAN := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
WPA_SUPPLICANT_VERSION := VER_0_8_X
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"

# Charger / backlight
BACKLIGHT_PATH := /sys/class/leds/lcd-backlight/brightness
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_NO_CHARGER_LED := true

# Misc
MALLOC_SVELTE := true
EXTENDED_FONT_FOOTPRINT := true
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
BOARD_HAS_NO_SELECT_BUTTON := true
TARGET_USERIMAGES_USE_F2FS := false

# The stock 3.4 kernel only reads SELinux policy up to version 26 (Android 7.1 defaults to 30).
POLICYVERS := 26

# GMHCOOS boot animation (lime green wordmark, gmhco.org)
TARGET_BOOTANIMATION := device/lenovo/b8080f/bootanimation.zip

# Stock KK camera stack blobs (libmmjpeg etc.) contain text relocations; exempt platform binaries from the N dlopen ban
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true

# HAL1 recording frames must travel as native_handle over binder (N marshalling); without this the
# camera HAL tags frames kMetadataBufferTypeCameraSource and the foreign pointer dies cross-process
TARGET_USES_MEDIA_EXTENSIONS := true

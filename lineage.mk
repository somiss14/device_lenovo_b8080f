# Lenovo Yoga Tablet 10 HD+ (B8080-F, Wi-Fi only) - LineageOS 14.1 (Android 7.1)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, vendor/cm/config/common_full_tablet_wifionly.mk)
$(call inherit-product, device/lenovo/b8080f/device.mk)

PRODUCT_NAME := lineage_b8080f
PRODUCT_DEVICE := b8080f
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := B8080-F
PRODUCT_MANUFACTURER := LENOVO
PRODUCT_GMS_CLIENTID_BASE := android-lenovo

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),b8080f)

# The Qualcomm HALs (bt / display / audio / media) expect the kernel's exported UAPI headers at
# $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr, which normally only exist when the kernel is built
# from source. This device boots Lenovo's prebuilt stock kernel (see BoardConfig.mk), so only the
# headers are exported here from Lenovo's kernel source.
B8080F_KERNEL_SRC := kernel/lenovo/b8080f-uapi-src
B8080F_KERNEL_OBJ := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ

$(B8080F_KERNEL_OBJ)/usr:
	@echo "Exporting kernel UAPI headers from $(B8080F_KERNEL_SRC)"
	$(hide) mkdir -p $(B8080F_KERNEL_OBJ)
	$(hide) $(MAKE) -C $(B8080F_KERNEL_SRC) O=$(abspath $(B8080F_KERNEL_OBJ)) ARCH=arm headers_install > /dev/null

include $(call all-makefiles-under,$(LOCAL_PATH))

# The stock system reaches per-unit calibration and secure-app firmware through symlinks into
# /persist, /data and /firmware (mounted at runtime). PRODUCT_COPY_FILES cannot create symlinks.
B8080F_FW_LINKS := \
    wlan/prima/WCNSS_qcom_wlan_nv.bin:/persist/WCNSS_qcom_wlan_nv.bin \
    wlan/prima/WCNSS_qcom_cfg.ini:/data/misc/wifi/WCNSS_qcom_cfg.ini \
    wcd9306/wcd9306_mbhc.bin:/data/misc/audio/mbhc.bin \
    wcd9306/wcd9306_anc.bin:/data/misc/audio/wcd9320_anc.bin \
    cmnlib.b00:/firmware/image/cmnlib.b00 cmnlib.b01:/firmware/image/cmnlib.b01 \
    cmnlib.b02:/firmware/image/cmnlib.b02 cmnlib.b03:/firmware/image/cmnlib.b03 \
    cmnlib.mdt:/firmware/image/cmnlib.mdt \
    dxhdcp2.b00:/firmware/image/dxhdcp2.b00 dxhdcp2.b01:/firmware/image/dxhdcp2.b01 \
    dxhdcp2.b02:/firmware/image/dxhdcp2.b02 dxhdcp2.b03:/firmware/image/dxhdcp2.b03 \
    dxhdcp2.mdt:/firmware/image/dxhdcp2.mdt

define b8080f-fw-link
$(TARGET_OUT_ETC)/firmware/$(1):
	@mkdir -p $$(dir $$@)
	$$(hide) ln -sf $(2) $$@
ALL_DEFAULT_INSTALLED_MODULES += $(TARGET_OUT_ETC)/firmware/$(1)
endef
$(foreach l,$(B8080F_FW_LINKS),$(eval $(call b8080f-fw-link,$(word 1,$(subst :, ,$(l))),$(word 2,$(subst :, ,$(l))))))

define b8080f-vendor-fw-link
$(TARGET_OUT_VENDOR)/firmware/$(1):
	@mkdir -p $$(dir $$@)
	$$(hide) ln -sf /firmware/image/$(1) $$@
ALL_DEFAULT_INSTALLED_MODULES += $(TARGET_OUT_VENDOR)/firmware/$(1)
endef
$(foreach f,widevine.b00 widevine.b01 widevine.b02 widevine.b03 widevine.mdt,$(eval $(call b8080f-vendor-fw-link,$(f))))

# Genuine GPU/codec/CPP firmware copied verbatim from the stock 4.4.2 system partition
# (device tree folder firmware-prebuilt/, sha256-verified against Lenovo S102208_141114).
# The 3.4 Adreno kernel driver hits BUG() at adreno_init() (adreno.c:1912) and panics the
# whole boot the first time SurfaceFlinger opens /dev/kgsl-3d0 unless the a330 PFP+PM4
# microcode is present in /system/etc/firmware.
B8080F_FW_PREBUILT := device/lenovo/b8080f/firmware-prebuilt/firmware
B8080F_FW_FILES := a225_pfp.fw a225_pm4.fw a225p5_pm4.fw a300_pfp.fw a300_pm4.fw \
    a330_pfp.fw a330_pm4.fw cpp_firmware_v1_1_1.fw cpp_firmware_v1_1_6.fw \
    cpp_firmware_v1_2_0.fw leia_pfp_470.fw leia_pm4_470.fw \
    venus.b00 venus.b01 venus.b02 venus.b03 venus.b04 venus.mbn venus.mdt \
    widevine.b00 widevine.b01 widevine.b02 widevine.b03 widevine.mdt \
    wlan/prima/WCNSS_cfg.dat

define b8080f-copy-fw
$(TARGET_OUT_ETC)/firmware/$(1): $(B8080F_FW_PREBUILT)/$(1)
	@mkdir -p $$(dir $$@)
	$$(copy-file-to-target)
ALL_DEFAULT_INSTALLED_MODULES += $(TARGET_OUT_ETC)/firmware/$(1)
endef
$(foreach f,$(B8080F_FW_FILES),$(eval $(call b8080f-copy-fw,$(f))))

endif

# device_lenovo_b8080f

LineageOS 14.1 (Android 7.1.2) device tree for the **Lenovo Yoga Tablet 10 HD+ (B8080-F, Wi-Fi)** — APQ8028/msm8226, stock 3.4.0 Lenovo kernel (prebuilt + UAPI headers).

Status, flashing instructions and prebuilt images: see the [Release](https://github.com/somiss14/device_lenovo_b8080f/releases/tag/v14.1-20261126).

## Manifest snippet (place beside the lineage-14.1 manifest)
```xml
<project path="device/lenovo/b8080f" name="device_lenovo_b8080f" groups="device" remote="somiss14" revision="b8080f-14.1"/>
<project path="vendor/lenovo/b8080f" name="vendor_lenovo_b8080f" groups="device" remote="somiss14" revision="b8080f-14.1"/>
<project path="frameworks/av" name="android_frameworks_av" remote="somiss14" revision="b8080f-14.1"/>
<project path="frameworks/base" name="android_frameworks_base" remote="somiss14" revision="b8080f-14.1"/>
<project path="frameworks/opt/net/wifi" name="android_frameworks_opt_net_wifi" remote="somiss14" revision="b8080f-14.1"/>
<project path="system/core" name="android_system_core" remote="somiss14" revision="b8080f-14.1"/>
<project path="system/sepolicy" name="android_system_sepolicy" remote="somiss14" revision="b8080f-14.1"/>
<project path="system/netd" name="android_system_netd" remote="somiss14" revision="b8080f-14.1"/>
<project path="hardware/qcom/media-caf/msm8974" name="android_hardware_qcom_media" remote="somiss14" revision="b8080f-14.1"/>
<project path="hardware/qcom/display-caf/msm8974" name="android_hardware_qcom_display" remote="somiss14" revision="b8080f-14.1"/>
<project path="hardware/qcom/bt-caf" name="android_hardware_qcom_bt" remote="somiss14" revision="b8080f-14.1"/>
<project path="vendor/cmsdk" name="android_vendor_cmsdk" remote="somiss14" revision="b8080f-14.1"/>
<project path="kernel/lenovo/b8080f-uapi-src" name="android_kernel_lenovo_b8080f" remote="somiss14" revision="b8080f-14.1"/>
```
with
```xml
<remote name="somiss14" fetch="https://github.com/somiss14/" />
```
Build: `source build/envsetup.sh && lunch lineage_b8080f-userdebug && make bacon`.

The Chromium 119 WebView used on this board is the standard LineageOS prebuilt (`LineageOS/android_external_chromium-webview_prebuilt_arm`, needs `git lfs` to materialize `webview.apk`, sha256 `feeedd44677f5643e2de2de4a44061f7bd31a662e78909d6e052b4fe1468870a`).

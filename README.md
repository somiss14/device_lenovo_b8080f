# Lenovo Yoga Tablet 10 HD+ (B8080-F) — GMHCOOS device tree

LineageOS 14.1 (Android 7.1.2) for the Wi-Fi-only Lenovo Yoga Tablet 10 HD+, model **B8080-F**:
Snapdragon 400 (MSM8226/APQ8028), Adreno 305, 2 GB RAM, 1920×1200 panel, kernel 3.4. Stock shipped
Android 4.4.2 with Chrome 35 and was never updated by Lenovo (not in Lenovo's own Android Upgrade
Matrix). No prior port ever reached a public release for this exact model.

## Hardware status

| | |
|---|---|
| Boot / display | Working (see the MDP overlay ABI fix below) |
| Touchscreen | Working |
| Wi-Fi | Working (scan, connect, internet — needs the netd + module-loader fixes below) |
| Bluetooth | Stack comes up (SMD transport); pairing/printing with a real accessory not yet confirmed |
| Sensors / auto-rotate | Working (accelerometer, magnetometer, light — behind the ADSP) |
| WebView / browser | Working, forced to software rendering (GPU raster bug workaround) |
| Camera | Untested |
| GPS | Untested — this is the Wi-Fi-only B8080-F, likely no GPS hardware at all |
| Audio | Untested beyond boot chime |
| Bluetooth printer / POS use | Not yet confirmed end-to-end |

## Bugs found and fixed (the interesting part)

### 1. Display was completely blank — only the boot logo ever showed

Android booted fine underneath (adb worked, `screencap` produced a correct-looking PNG), but the
physical panel never showed anything past the OEM logo. `dmesg` showed the kernel rejecting *every*
overlay commit:

```
mdss_mdp_overlay_pipe_setup: invalid pipe ndx=2
```

thousands of times per boot. The cause: `struct mdp_overlay` (the ioctl struct HWC uses to hand a
frame to the display driver) has a `pipe_type` field in the 3.10-era Qualcomm headers this LineageOS
branch's display HAL was built against, positioned *before* `id`. This stock 3.4 kernel's own
`struct mdp_overlay` doesn't have that field there — it reads the same 4 bytes as `id`, gets the
pipe-type constant (2 = DMA) instead, and rejects the request because pipe #2 was never allocated.

Confirmed on-device with a small ioctl probe (`scripts/ovtest.c` in the parent repo's history) that
tries both layouts directly against `/dev/graphics/fb0`. Fixed by moving `pipe_type` to the end of
the struct in the exported kernel UAPI header and turning HWC's writes to it into a no-op
(`patches/README-mdp-overlay-abi.txt` has both diffs). **Lesson for anyone repeating this kind of
port: a `screencap` or a logcat that "looks fine" is not evidence the physical panel shows anything.
Only a person looking at the screen is.**

### 2. Wi-Fi connects but says "no internet"

The kernel accepted an IP address over DHCP but network validation always failed with instant DNS
failures. `netd`'s `RouteController` sets up a small UID-scoped routing rule
(`modifyOutputInterfaceRules`) as part of bringing an interface onto a network; that rule needs
`FRA_UID_RANGE`, which doesn't exist in kernel 3.4 (added in mainline Linux 4.9-ish / backported by
some OEM kernels, not this one). The rule add fails with `EINVAL`, and netd aborts the rest of
`addInterfaceToNetwork()` — so the interface gets an address but no default route or DNS servers.
Fixed by making that one rule-add path tolerate `EINVAL`/`ENOENT`/`EOPNOTSUPP`
(`patches/system_netd-ignore-uidrange-rule-failures.patch`) — it only affects VPN/per-UID routing,
which this device doesn't use anyway.

### 3. Wi-Fi driver wouldn't load at boot

Kernel 3.4 has `init_module` but not `finit_module`, which stock Android 7.1 `init`'s built-in
module loader (and the wifi HAL's `WIFI_DRIVER_MODULE_PATH` mechanism) both require. Ships a tiny
static ARM binary (`scripts/insmod_test.c`, installed as `/insmod_legacy`) that calls
`init_module` directly, run as a oneshot service from `rootdir/init.qcom.rc`. Two gotchas if you're
adapting this: the ramdisk installs files `0644`, so `chmod 0755` it in `on early-init` — after
rootfs goes read-only later in boot, that chmod can no longer happen; and the stock `wpa_supplicant`
service definitions were missing from every 3rd-party init.rc we found for this device, so they're
recreated here too.

### 4. No auto-rotate — 0 sensors visible to Android

The LSM303D accelerometer/magnetometer and AL3320B light sensor sit behind the Snapdragon's ADSP
co-processor, which nothing was booting. `rootdir/sensors_start.sh` writes
`/sys/kernel/boot_adsp/boot`, waits for `subsys0` to report `ONLINE`, then starts the stock
`sensors.qcom` daemon (a proprietary blob — see `proprietary-files.txt`). Once that's running,
`dumpsys sensorservice` reports all 22 fused sensors and auto-rotate works normally.

### 5. Bluetooth wouldn't come up

`libbt-vendor`'s `get_bt_soc_type()` defaults to an H4 UART HCI driver when `qcom.bluetooth.soc`
isn't set, and this hardware doesn't expose that transport — you'd see
`hal_open opened the wrong number of ports: got 2, expected 1`. Setting
`qcom.bluetooth.soc=smd` in `system.prop` picks the correct SMD transport and the adapter turns on
and stays on. Pairing with a real device (in particular, a Bluetooth receipt printer, this port's
original motivation) hasn't been confirmed yet — if you get that working, please open a PR.

### 6. WebView (and the browser, and any Capacitor/Cordova/hybrid app) drew garbled tiles and text

Chromium 119's GPU-accelerated rasterizer corrupts small text and tile uploads on this specific
Adreno 305 (`OpenGL ES 3.0 V@66.0`) — no Chromium command-line flag we tried fixed it
(`--disable-gpu-rasterization`, `--disable-zero-copy`, `--disable-es3-gl-context`, combinations of
all three). Every `WebView` on the device now draws with `LAYER_TYPE_SOFTWARE`
(`patches/frameworks_base-webview-software-layer.patch`, gated on
`ro.webview.software_layer=true`). This costs some rendering performance but is the only thing that
produced correct pixels.

## Known open issues

- **Not hardened.** `ro.secure=0`, forced-permissive SELinux, and a baked adb key are all still set
  for bring-up (see `BoardConfig.mk` and `system.prop`). Turn these off before giving this to an
  end user; nothing has been done here to make that safe by default yet.
- Bluetooth pairing/printing with a real accessory is unconfirmed.
- Battery life, thermal behavior, and camera are unconfirmed.
- The stock kernel's own published GPL source (Lenovo's open-source site) is *older* than the
  binary kernel actually shipped on this tablet — verified on-hardware
  (the shipped binary accepts `MSMFB_OVERLAY_PREPARE`; Lenovo's published source predates that
  ioctl). The kernel and `dt.img` shipped in this device tree are therefore Lenovo's own compiled
  binaries pulled from a real tablet's stock boot image, not something built from source in this
  repo. UAPI headers used to build the display/BT/Wi-Fi HALs against are instead exported from
  [`LineageOS/android_kernel_motorola_msm8226`](https://github.com/LineageOS/android_kernel_motorola_msm8226)
  (`cm-14.1`), a same-generation (MSM8226, 3.4 kernel) device with source LineageOS already
  maintains, which was close enough in practice.

## Build

See the top-level repo README for the full `extract-files.sh` + `lunch` + `make` flow.

## Credits

DerCoop, master801 and TeamWin's earlier (incomplete/unreleased) B8080-F trees; the LineageOS and
Motorola-msm8226 kernel projects; Open GApps.

# meta-aos-rcar-gen3

This repository contains Renesas R-Car Gen3-specific Yocto layers for AosEdge distro.

## Requirements

1. Ubuntu 18.0+ or any other Linux distribution which is supported by Poky/OE

2. Development packages for Yocto. Refer to
[Yocto manual](https://www.yoctoproject.org/docs/current/mega-manual/mega-manual.html#brief-build-system-packages)

3. You need `Moulin` installed in your PC. Recommended way is to install it for your user only:

    ```sh
    pip3 install --user git+https://github.com/xen-troops/moulin`
    ```

    Make sure that your `PATH` environment variable includes `${HOME}/.local/bin`

4. Ninja build system on Ubuntu:

    ```sh
    sudo apt install ninja-build
    ```
  
5. Install Zephyr OS dependencies and SDK:
[Getting Started Guide](https://docs.zephyrproject.org/latest/develop/getting_started/index.html#)

6. Install [protobuf compiler](https://grpc.io/docs/protoc-installation/#install-pre-compiled-binaries-any-os) from
pre-compiled binaries. The verified protobuf compiler version is
[v22.3](https://github.com/protocolbuffers/protobuf/releases/tag/v22.3).

## Create image

### Fetch

You can fetch/clone this whole repository, but you actually only need one file from it: `aos-rcar-gen3.yaml`. During the
build `moulin` will fetch this repository again into `yocto/` directory. So, to reduce possible confuse, we recommend to
download only `aos-rcar-gen3.yaml`:

```sh
curl -O https://raw.githubusercontent.com/aoscloud/meta-aos-rcar-gen3/main/aos-rcar-gen3.yaml
```

### Build

Moulin is used to generate Ninja build file: `moulin aos-rcar-gen3.yaml`. This project provides number of additional
parameters. You can check them with `--help-config` command line option:

```sh
moulin aos-rcar-gen3.yaml --help-config   
usage: moulin aos-rcar-gen3.yaml [--MACHINE {salvator-xs-m3-2x4g,salvator-xs-h3-4x2g,salvator-x-h3-4x2g,h3ulcb-4x2g,h3ulcb-4x2g-kf,h3ulcb-4x2g-ab}]
                                 [--ENABLE_MM {no,yes}]
                                 [--PREBUILT_DDK {no,yes}] [--VIS_DATA_PROVIDER {renesassimulator,telemetryemulator}]
                                 [--NODE_TYPE {single,secondary}]

Config file description: Aos development setup for Renesas RCAR Gen3 hardware

options:
  --MACHINE {salvator-xs-m3-2x4g,salvator-xs-h3-4x2g,salvator-x-h3-4x2g,h3ulcb-4x2g,h3ulcb-4x2g-kf,h3ulcb-4x2g-ab}
                        RCAR Gen3-based device
  --ENABLE_MM {no,yes}  Enable Multimedia support
  --PREBUILT_DDK {no,yes}
                        Use pre-built GPU drivers
  --VIS_DATA_PROVIDER {renesassimulator,telemetryemulator}
                        Specifies plugin for VIS automotive data
  --NODE_TYPE {single,secondary}
                        Node type to build

```

Currently only the following machines are supported: `h3ulcb-4x2g`, `salvator-xs-m3-2x4g`.
Two types of nodes can be built: `single` - where Gen3 board is single unit or `secondary` where Gen3 board is secondary
node in multi-node unit.

For example, to build the secondary node image for multi-node Aos unit, perform the following command:

```sh
moulin aos-rcar-gen3.yaml --NODE_TYPE secondary
```

Other options enable different image features. See
[prod-devel-rcar](https://github.com/xen-troops/meta-xt-prod-devel-rcar/blob/master/README.md) for more details.

Moulin will generate `build.ninja` file that contains different build targets. Run `ninja` command to build image
components. This will take some time and disk space.

### Update firmware

Aos image requires specific firmware version to work properly. Updating the firmware should be done for each new Aos
release. Perform the following command in order to build firmware images:

```sh
ninja pack-ipl
```

It will generate firmware archive under `output/ipl` folder. Please use
[RCar flash tool](https://github.com/xen-troops/rcar_flash) to update the firmware.

### Flash image

To generate Aos image, issue the following command:

```sh
ninja full.img
```

It will generate `full.img` file in the current folder. In this product Aos image should be flashed on SD card only. The
easiest way to flash SD card is to attach it to the host PC and flash it using `rouge` or `dd` utility.

Using `dd` to flash SD card:

```sh
dd if=full.img of=/dev/sdX conv=sparse
```

Using `rouge` to flash SD card:

```sh
rouge aos-rcar-gen3.yaml -i full -so /dev/sdX
```

**BE SURE TO PROVIDE CORRECT DEVICE NAME**. `rouge` has no interactive prompts and will overwrite your device right
away. **ALL DATA WILL BE LOST**.

Alternatively, SD card can be flashed using BSP build or
[prod-devel-rcar](https://github.com/xen-troops/meta-xt-prod-devel-rcar/blob/master/README.md) launched over TFTP+NFS.
Once, the board is started, put `full.img` into NFS folder and copy the image into SD card, using the following command
on Gen3 board:

```sh
dd if=/full.img of=/dev/mmcblk1 bs=32M status=progress oflag=direct
```

If the board was provisioned before it is required to clean the zephyr storage in order to perform provisioning
procedure again:

```sh
dd if=/dev/zero of=/dev/mmcblk0 bs=32M count=1
```

### U-Boot environment

The following U-Boot variable should be set for Aos image:

```sh
setenv aos_device 'mmc 0'
setenv aos_boot_device 'mmcblk1'
setenv aos_default_vars 'setenv aos_boot_main 0; setenv aos_boot1_ok 1; setenv aos_boot2_ok 1; setenv aos_boot_part 0'
setenv aos_load_vars 'run aos_default_vars; if load ${aos_device}:3 ${loadaddr} uboot.env; then env import -t ${loadaddr} ${filesize}; fi'
setenv aos_save_vars 'env export -t ${loadaddr} aos_boot_main aos_boot_part aos_boot1_ok aos_boot2_ok; fatwrite ${aos_device}:3 ${loadaddr} uboot.env 0x3E'
setenv aos_boot1 'if test ${aos_boot1_ok} -eq 1; then setenv aos_boot1_ok 0; setenv aos_boot2_ok 1; setenv aos_boot_part 0; setenv aos_boot_slot 1; echo "==== Boot from part 1"; run aos_save_vars; run aos_boot_cmd; fi'
setenv aos_boot2 'if test ${aos_boot2_ok} -eq 1; then setenv aos_boot2_ok 0; setenv aos_boot1_ok 1; setenv aos_boot_part 1; setenv aos_boot_slot 2; echo "==== Boot from part 2"; run aos_save_vars; run aos_boot_cmd; fi'
setenv aos_boot_cmd 'ext2load ${aos_device}:${aos_boot_slot} 0x83000000 boot.uImage; source 0x83000000'
setenv bootcmd_aos 'run aos_load_vars; if test ${aos_boot_main} -eq 0; then run aos_boot1; run aos_boot2; else run aos_boot2; run aos_boot1; fi'
setenv bootcmd 'run bootcmd_aos'
```

## FOTA & Layers

* [Generate FOTA bundles](https://github.com/aoscloud/meta-aos-vm/blob/main/doc/fota.md)
* [Generate layers](https://github.com/aoscloud/meta-aos-vm/blob/main/doc/layers.md)

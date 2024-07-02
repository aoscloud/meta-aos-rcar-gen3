require u-boot-domd.inc

HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
DESCRIPTION = "This is version of the U-Boot customized/hacked for the boot of the DomD under Zephyr OS"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
PE = "1"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"
do_configure[cleandirs] = "${B}"

DEPENDS:append = " flex-native bison-native lzop-native srecord-native"

UBOOT_URL = "git://github.com/xen-troops/u-boot.git"
BRANCH = "zephyr_rcar_ipl_v2023.10"

SRC_URI = "${UBOOT_URL};branch=${BRANCH};protocol=https"
SRCREV = "06acc987acf156b27990d23b9e80b8e973226ed1"
PV = "v2020.10+git${SRCPV}"

UBOOT_CONFIG = "rcar3_xen_defconfig"
UBOOT_CONFIG[rcar3_xen_defconfig] = "rcar3_xen_defconfig"

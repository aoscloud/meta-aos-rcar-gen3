SUMMARY = "Boot scripts for R-Car Gen3 board"
DESCRIPTION = "Set of U-boot scripts that automate boot process on -Car Gen3 board"

PV = "0.1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit deploy

DEPENDS += "u-boot-mkimage-native"

SRC_URI = " \
    file://boot.cmd \
"

do_configure[noexec] = "1"
do_install[noexec] = "1"

do_compile() {
    uboot-mkimage -T script -d ${WORKDIR}/boot.cmd ${B}/boot.uImage
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${B}/boot.uImage ${DEPLOYDIR}/boot.uImage
}

addtask deploy before do_build after do_compile

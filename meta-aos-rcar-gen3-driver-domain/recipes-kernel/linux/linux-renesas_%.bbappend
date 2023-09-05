FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://defconfig \
    file://0001-clk-sdhi-Disable-sdhi-clocks.patch \
"

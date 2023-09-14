FILESEXTRAPATHS:prepend := "${THISDIR}/files:\
${@bb.utils.contains('DISTRO_FEATURES', 'enable_virtio',\
'${THISDIR}/files/virtio:',\
'${THISDIR}/files/pvr:',\
d)}\
"

SRC_URI:append = " \
    file://defconfig \
    file://0001-clk-sdhi-Disable-sdhi-clocks.patch \
"
SUMMARY = "Aos image for Renesas RCAR devices"

require recipes-graphics/images/core-image-weston.bb
require recipes-core/images/aos-image.inc

IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'enable_virtio', ' virglrenderer libsdl2 qemu-system-aarch64 qemu-keymaps', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'pvcamera', 'camerabe', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'sndbe', 'sndbe', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'displbe', 'displbe', '', d)} \
"

IMAGE_INSTALL:append = " \
    xen \
    xen-tools-devd \
    xen-tools-scripts-network \
    xen-tools-scripts-block \
    xen-tools-xenstore \
    xen-network \
    dnsmasq \
    block \
    ${@bb.utils.contains('DISTRO_FEATURES', 'ivi-shell', 'displaymanager', '', d)} \
"

IMAGE_INSTALL:append = " \
   aos-messageproxy \
"

# Set fixed rootfs size
IMAGE_ROOTFS_SIZE = "1048576"
IMAGE_OVERHEAD_FACTOR = "1.0"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

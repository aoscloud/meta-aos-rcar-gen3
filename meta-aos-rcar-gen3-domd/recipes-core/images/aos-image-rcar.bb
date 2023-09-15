SUMMARY = "Aos image for Renesas RCAR devices"

require recipes-graphics/images/core-image-weston.bb
require recipes-core/images/aos-image.inc

IMAGE_INSTALL:append = " \
    aos-messageproxy \
    ${@bb.utils.contains('DISTRO_FEATURES', 'enable_virtio', ' virglrenderer libsdl2 qemu-system-aarch64 qemu-keymaps', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'pvcamera', 'camerabe', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'vis', 'aos-vis', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'sndbe', 'sndbe', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'displbe', 'displbe', '', d)} \
"

# We add 500 MB of free space for media content.
# Variable specifies space in KBytes.
# Also see IMAGE_OVERHEAD_FACTOR as another way to increase free space.
IMAGE_ROOTFS_EXTRA_SPACE = "512000"

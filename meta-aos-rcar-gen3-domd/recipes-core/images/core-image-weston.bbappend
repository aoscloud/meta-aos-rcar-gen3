require recipes-core/images/aos-image.inc

IMAGE_INSTALL:append = "\
    ${@bb.utils.contains('DISTRO_FEATURES', 'enable_virtio', ' virglrenderer libsdl2 qemu-system-aarch64 qemu-keymaps', '', d)} \
"

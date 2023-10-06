do_install:append() {
    sed -i '/\/sbin\/reboot/i \
    sync\n\
    xenstore-write control/user-reboot 2' ${D}${bindir}/${SELINUX_SCRIPT_SRC}.sh
}

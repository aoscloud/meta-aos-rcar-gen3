do_install:append:aos-main-node() {
    echo "bind-dynamic" >> ${D}${sysconfdir}/dnsmasq.conf
}

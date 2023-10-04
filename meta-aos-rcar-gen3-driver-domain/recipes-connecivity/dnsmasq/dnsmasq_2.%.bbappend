do_install:append() {
    # Set domain
    echo "local=/gen3/" >> ${D}${sysconfdir}/dnsmasq.conf
    echo "domain=gen3" >> ${D}${sysconfdir}/dnsmasq.conf
    echo "expand-hosts" >> ${D}${sysconfdir}/dnsmasq.conf
}

do_install:append:aos-secondary-node() {
    # Serve eth0
    echo "interface=eth0" >> ${D}${sysconfdir}/dnsmasq.conf
    # Add gen4 DNS server
    echo "server=/gen4/10.0.0.1" >> ${D}${sysconfdir}/dnsmasq.conf
}

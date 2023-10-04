FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend:aos-secondary-node := "${THISDIR}/files/secondary-node:"

SRC_URI += " \
    file://interface-forward-systemd-networkd.conf \
"

FILES:${PN} += " \
    ${sysconfdir} \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/
    install -m 0644 ${S}/interface-forward-systemd-networkd.conf ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
}

do_install:append:aos-secondary-node() {
    mv ${D}${sysconfdir}/systemd/network/eth0.network ${D}${sysconfdir}/systemd/network/10-eth0.network
}

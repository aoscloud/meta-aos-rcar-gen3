hostname:aos-secondary-node = ""

do_install:append:aos-secondary-node() {
   echo ${AOS_NODE_HOSTNAME} > ${D}${sysconfdir}/hostname
}

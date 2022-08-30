FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "git://git@github.com/al1img/aos_iamanager.git;branch=gen4_integration;protocol=ssh"
SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    file://aos_iamanager.cfg \
    file://aos-iamanager.service \
    file://domd_provfinish.sh \
"

AOS_IAM_CERT_MODULES = " \
    certhandler/modules/pkcs11module \
    certhandler/modules/swmodule \
"

AOS_IAM_IDENT_MODULES = " \
    identhandler/modules/visidentifier \
"

MIGRATION_SCRIPTS_PATH = "${base_prefix}/usr/share/aos/iam/migration"

inherit systemd

SYSTEMD_SERVICE_${PN} = "aos-iamanager.service"

FILES_${PN} += " \
    ${sysconfdir} \
    ${systemd_system_unitdir} \
    ${aos_opt_dir} \
    ${MIGRATION_SCRIPTS_PATH} \
"

RDEPENDS_${PN} = " \
    aos-provfirewall \
    aos-provfinish \
    aos-rootca \
    aos-setupdisk \
    optee-pkcs11-ta \
    optee-client \
"

do_install_append() {
    install -d ${D}${sysconfdir}/aos
    install -m 0644 ${WORKDIR}/aos_iamanager.cfg ${D}${sysconfdir}/aos

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/aos-iamanager.service ${D}${systemd_system_unitdir}

    install -d ${D}${aos_opt_dir}
    install -m 0755 ${WORKDIR}/domd_provfinish.sh ${D}${aos_opt_dir}

    install -d ${D}${MIGRATION_SCRIPTS_PATH}
    source_migration_path="/src/${GO_IMPORT}/database/migration"
    if [ -d ${S}${source_migration_path} ]; then
        install -m 0644 ${S}${source_migration_path}/* ${D}${MIGRATION_SCRIPTS_PATH}
    fi
}

pkg_postinst_${PN}() {
    # Add aosiam to /etc/hosts
    if ! grep -q 'aosiam' $D${sysconfdir}/hosts ; then
        echo '192.168.0.3	aosiam' >> $D${sysconfdir}/hosts
    fi

    # Add wwwivi to /etc/hosts
    if ! grep -q 'wwwivi' $D${sysconfdir}/hosts ; then
        echo '192.168.0.1	wwwivi' >> $D${sysconfdir}/hosts
    fi
}

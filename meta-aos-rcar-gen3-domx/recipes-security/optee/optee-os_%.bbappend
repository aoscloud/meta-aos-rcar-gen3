require optee.inc

EXTRA_OEMAKE += " \
    CFG_NS_VIRTUALIZATION=y \
    CFG_VIRT_GUEST_COUNT=3 \
    CFG_PKCS11_TA_HEAP_SIZE="(256 * 1024)" \
"

# Enable Android-specific features if we are building Android guest
ANDROID_EXTRA_OEMAKE = " \
	CFG_ASN1_PARSER=y \
    CFG_CORE_MBEDTLS_MPI=y \
	CFG_RPMB_FS=y \
    CFG_RPMB_WRITE_KEY=y \
	CFG_EARLY_TA=y \
	CFG_IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067 \
"

EXTRA_OEMAKE += "${@bb.utils.contains('XT_GUEST_INSTALL', 'doma', '${ANDROID_EXTRA_OEMAKE}', '', d)}"

do_install:append() {
    install -m 644 ${B}/core/tee.srec ${D}${nonarch_base_libdir}/firmware/tee.srec
}

TA_PKCS11_UUID = "fd02c9da-306c-48c7-a49c-bbd827ae86ee"

do_deploy:append(){
    install -d ${DEPLOYDIR}
    ln -sfr ${DEPLOYDIR}/${MLPREFIX}optee/tee.srec ${DEPLOYDIR}/tee-${MACHINE}.srec
    ln -sfr ${DEPLOYDIR}/${MLPREFIX}optee/tee-raw.bin ${DEPLOYDIR}/tee-${MACHINE}.bin

    install -d ${DEPLOYDIR}/aos/ta
    install -m 0644 ${B}/ta/pkcs11/${TA_PKCS11_UUID}.ta ${DEPLOYDIR}/aos/ta
}

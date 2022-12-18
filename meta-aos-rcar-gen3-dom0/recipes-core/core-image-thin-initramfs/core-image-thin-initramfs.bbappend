# Aos related tasks

IMAGE_POSTPROCESS_COMMAND += "set_image_version; "

IMAGE_INSTALL_append = " runx"

set_image_version() {
    install -d ${DEPLOY_DIR_IMAGE}/aos
    echo "VERSION=\"${DOM0_IMAGE_VERSION}\"" > ${DEPLOY_DIR_IMAGE}/aos/version
}

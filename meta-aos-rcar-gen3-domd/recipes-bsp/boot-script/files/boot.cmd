# Default Aos vars

setenv aos_boot_main 0
setenv aos_boot1_ok 1
setenv aos_boot2_ok 1
setenv aos_boot_part 0

if test -z "${aos_device}"; then
  setenv aos_device 'mmc 0'
fi

if test -z "${aos_boot_device}; then
  setenv aos_boot_device 'mmcblk1'
fi

# Load Aos vars

if load ${aos_device}:3 ${loadaddr} uboot.env; then
  env import -t ${loadaddr} ${filesize}
fi

# Check main boot

setenv aos_boot1 'if test ${aos_boot1_ok} -eq 1; then setenv aos_boot1_ok 0; setenv aos_boot2_ok 1; setenv aos_boot_part 0; setenv aos_boot_slot 1; echo "==== Boot from part 1"; fi'
setenv aos_boot2 'if test ${aos_boot2_ok} -eq 1; then setenv aos_boot2_ok 0; setenv aos_boot1_ok 1; setenv aos_boot_part 1; setenv aos_boot_slot 2; echo "==== Boot from part 2"; fi'

if test ${aos_boot_main} -eq 0; then
  run aos_boot1
  run aos_boot2
else
  run aos_boot2
  run aos_boot1
fi

# Save Aos vars

env export -t ${loadaddr} aos_boot_main aos_boot_part aos_boot1_ok aos_boot2_ok
fatwrite ${aos_device}:3 ${loadaddr} uboot.env 0x3E

# Start Image

ext2load ${aos_device}:${aos_boot_slot} 0x48080000 xen
ext2load ${aos_device}:${aos_boot_slot} 0x48000000 xen.dtb
ext2load ${aos_device}:${aos_boot_slot} 0x8e000000 xenpolicy
ext2load ${aos_device}:${aos_boot_slot} 0x8a000000 zephyr.bin

fdt addr 0x48000000
fdt resize
fdt mknode / boot_dev
fdt set /boot_dev device ${aos_boot_device}

bootm 0x48080000 - 0x48000000

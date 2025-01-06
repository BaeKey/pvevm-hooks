#!/bin/bash

VMID="$1"
LOG_DIR=$(dirname $0)
LOG_FILE="$LOG_DIR/$VMID-hooks.log"

# 清理旧的日志文件
if [ -f "$LOG_FILE" ]; then
    > "$LOG_FILE"
fi

igd_id="8086 $(lspci -n|grep '0:02.0'|cut -d ':' -f4|cut -c 1-4)"

echo "VM $VMID is starting "$(date "+%Y-%m-%d %H:%M:%S") >> "$LOG_FILE"

sleep 1

echo 0000:00:02.0 > /sys/bus/pci/drivers/i915/unbind
if ! lsmod | grep "vfio_pci" &> /dev/null ; then
    modprobe vfio-pci
fi
echo $igd_id > /sys/bus/pci/drivers/vfio-pci/new_id

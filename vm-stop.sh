#!/bin/bash

VMID="$1"
LOG_DIR=$(dirname $0)
LOG_FILE="$LOG_DIR/$VMID-hooks.log"

igd_id="8086 $(lspci -n|grep '0:02.0'|cut -d ':' -f4|cut -c 1-4)"

sleep 30

# 等待虚拟机停止
TimeSec=0
until ! test -e "/var/run/qemu-server/$VMID.pid"
do
    sleep 3
done

echo 0000:00:02.0 > /sys/bus/pci/drivers/vfio-pci/unbind
echo $igd_id > /sys/bus/pci/drivers/vfio-pci/remove_id
echo 0000:00:02.0 > /sys/bus/pci/drivers/i915/bind

sleep 1

# 记录虚拟机停止
echo "VM $VMID stopped "$(date "+%Y-%m-%d %H:%M:%S") >> "$LOG_FILE"
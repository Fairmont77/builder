#!/bin/bash

# E3372h LTE Modem Configuration Script
# This script configures Huawei E3372h USB LTE modem

# Load USB modules
modprobe usbserial
modprobe option
modprobe cdc_ether
modprobe cdc_ncm
modprobe huawei_cdc_ncm

# Add Huawei E3372h vendor/product IDs
echo "12d1 1f01" > /sys/bus/usb-serial/drivers/option1/new_id
echo "12d1 14db" > /sys/bus/usb-serial/drivers/option1/new_id

# Switch E3372h from storage mode to modem mode using usb_modeswitch
if [ -e /dev/sr0 ]; then
    echo "Switching E3372h from storage to modem mode..."
    usb_modeswitch -v 12d1 -p 1f01 -M "55534243123456780000000000000a11062000000000000100000000000000"
    sleep 5
fi

# Configure network interface for LTE connection
if [ -e /sys/class/net/eth1 ]; then
    echo "Configuring LTE network interface..."
    ip link set eth1 up
    dhclient eth1
fi

echo "E3372h LTE modem configuration completed"

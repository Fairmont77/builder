#!/bin/bash

# Enhanced LTE setup script for both QMI and E3372h modems
# Based on drop version but with fallback support

log() {
    echo "[$(date)] $1" | tee -a /var/log/lte_setup.log
}

setup_qmi_modem() {
    log "Setting up QMI modem..."
    
    # Wait for QMI device
    for i in {1..30}; do
        if [ -e /dev/cdc-wdm0 ]; then
            break
        fi
        log "Waiting for QMI device... ($i/30)"
        sleep 1
    done
    
    if [ ! -e /dev/cdc-wdm0 ]; then
        log "QMI device not found, trying E3372h setup..."
        return 1
    fi
    
    # Setup QMI connection
    ip link set wwan0 down
    echo Y > /sys/class/net/wwan0/qmi/raw_ip
    ip link set wwan0 up
    
    log "Configuring QMI autoconnect..."
    qmicli -p -d /dev/cdc-wdm0 --wds-set-autoconnect-settings=enabled
    
    log "Starting network connection..."
    qmicli -p -d /dev/cdc-wdm0 --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network="apn='o2internet',ip-type=4" --client-no-release-cid
    
    log "Getting IP address via DHCP..."
    udhcpc -q -i wwan0
    
    if ip addr show wwan0 | grep -q "inet "; then
        log "QMI modem setup successful"
        return 0
    else
        log "QMI setup failed, trying E3372h..."
        return 1
    fi
}

setup_e3372h_modem() {
    log "Setting up E3372h modem..."
    
    # Wait for USB device
    for i in {1..30}; do
        if lsusb | grep -q "12d1:"; then
            break
        fi
        log "Waiting for E3372h device... ($i/30)"
        sleep 1
    done
    
    # Switch to modem mode if needed
    if lsusb | grep -q "12d1:1f01"; then
        log "Switching E3372h to modem mode..."
        usb_modeswitch -v 12d1 -p 1f01 -c /etc/usb_modeswitch.conf
        sleep 5
    fi
    
    # Check for network interface
    for i in {1..30}; do
        if ip link show | grep -q "eth1\|usb0\|enx"; then
            IFACE=$(ip link show | grep -o "eth1\|usb0\|enx[a-f0-9]*" | head -1)
            break
        fi
        log "Waiting for E3372h network interface... ($i/30)"
        sleep 1
    done
    
    if [ -z "$IFACE" ]; then
        log "E3372h network interface not found"
        return 1
    fi
    
    log "Found E3372h interface: $IFACE"
    
    # Bring up interface and get IP
    ip link set $IFACE up
    udhcpc -q -i $IFACE
    
    if ip addr show $IFACE | grep -q "inet "; then
        log "E3372h modem setup successful on $IFACE"
        return 0
    else
        log "E3372h setup failed"
        return 1
    fi
}

# Main setup logic
log "Starting LTE modem setup..."

# Try QMI first (preferred for modern modems)
if setup_qmi_modem; then
    exit 0
fi

# Fallback to E3372h setup
if setup_e3372h_modem; then
    exit 0
fi

log "All LTE setup methods failed"
exit 1

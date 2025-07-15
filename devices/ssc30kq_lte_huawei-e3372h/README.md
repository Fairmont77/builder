# SSC30KQ with Huawei E3372h LTE Support

This firmware adds LTE support for SSC30KQ cameras using Huawei E3372h USB modem.

## Features
- Based on SSC30KQ Ultimate firmware
- Huawei E3372h USB modem support
- Automatic modem initialization
- DHCP client for automatic IP configuration
- USB CDC Ethernet support

## Installation

1. Build the firmware:
```bash
cd /path/to/LTE_link/builder
./builder.sh ssc30kq_lte_huawei-e3372h
```

2. Flash the firmware to your camera using the standard OpenIPC flashing procedure.

## Configuration

### Enable LTE
```bash
fw_setenv wlandev rndis-e3372h
```

### Configure APN (if needed)
```bash
fw_setenv gsm_apn "your.apn.here"
fw_setenv gsm_user "username"
fw_setenv gsm_pass "password"
```

### Reboot to apply changes
```bash
reboot
```

## Troubleshooting

### Check if modem is detected
```bash
lsusb
# Should show: ID 12d1:14dc Huawei Technologies Co., Ltd.
```

### Check network interface
```bash
ifconfig -a
# Should show eth1 or usb0 with IP address
```

### Check modem logs
```bash
logread | grep LTE
```

### Manual modem initialization
```bash
/etc/wireless/modem rndis-e3372h
```

## Notes
- The Huawei E3372h works in HiLink mode (CDC Ethernet)
- The modem provides its own DHCP server
- Default modem IP is usually 192.168.8.1
- You can access modem web interface at http://192.168.8.1

## GPIO Pins (adjust according to your board)
- IR Cut Pin 1: GPIO 1
- IR Cut Pin 2: GPIO 2
- IR LED Pin: GPIO 3
- Speaker Pin: GPIO 5

You may need to adjust these pins in `/usr/share/openipc/customizer.sh` according to your specific board layout.

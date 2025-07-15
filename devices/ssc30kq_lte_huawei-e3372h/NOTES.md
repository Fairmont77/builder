# Technical Notes for SSC30KQ LTE Support

## Huawei E3372h Modem

The Huawei E3372h is a popular USB LTE modem that works in two modes:
1. **HiLink mode** (default) - appears as CDC Ethernet device
2. **Stick mode** - appears as serial modem

This firmware uses HiLink mode for simplicity.

### USB IDs
- Initial ID: 12d1:1f01
- After mode switch: 12d1:14dc

### Mode Switching
The modem is automatically switched using usb_modeswitch with the configuration:
```
usb_modeswitch -v 0x12d1 -p 0x1f01 -c /usr/share/usb_modeswitch/12d1:1f01
```

## Network Configuration

The modem creates a CDC Ethernet interface (usually eth1) and runs its own DHCP server:
- Modem IP: 192.168.8.1
- DHCP range: 192.168.8.2-192.168.8.255
- DNS: 192.168.8.1

## GPIO Configuration

The SSC30KQ board may require specific GPIO pins for:
- USB power enable
- USB reset
- LED indicators

Current configuration (adjust as needed):
- IR Cut Pin 1: GPIO 1
- IR Cut Pin 2: GPIO 2  
- IR LED Pin: GPIO 3
- Speaker Pin: GPIO 5

## Debugging

### Check USB enumeration
```bash
cat /sys/kernel/debug/usb/devices
```

### Check kernel modules
```bash
lsmod | grep -E "rndis|cdc"
```

### Monitor modem initialization
```bash
dmesg | grep -E "usb|rndis|cdc"
```

### Check network interfaces
```bash
ip addr show
ip route show
```

## Known Issues

1. **Power consumption**: The LTE modem can draw significant power. Ensure adequate power supply.
2. **Heat**: The modem can get hot during operation. Consider ventilation.
3. **Signal strength**: Use external antenna for better signal if needed.

## Future Improvements

1. Add signal strength monitoring
2. Add SMS support
3. Add fallback to WiFi if LTE fails
4. Add data usage monitoring
5. Add support for other Huawei modems (E3372s, E8372h)

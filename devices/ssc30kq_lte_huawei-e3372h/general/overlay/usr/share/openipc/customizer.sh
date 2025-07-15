#!/bin/sh
#
# Perform basic settings on a known IP camera
#
#
# Set custom upgrade url
#
fw_setenv upgrade 'https://github.com/OpenIPC/builder/releases/download/latest/ssc30kq_lte_huawei-e3372h-nor.tgz'
#
# Set custom majestic settings
#
cli -s .nightMode.enabled true
cli -s .nightMode.irCutPin1 1
cli -s .nightMode.irCutPin2 2
cli -s .nightMode.backlightPin 3
cli -s .nightMode.colorToGray false
cli -s .video0.codec h265
cli -s .audio.speakerPin 5
#
# Set wlan device and credentials if need
#
fw_setenv wlandev rndis-e3372h
#
# Optional: Set APN for your mobile provider
# fw_setenv gsm_apn "internet"
# fw_setenv gsm_user ""
# fw_setenv gsm_pass ""


exit 0

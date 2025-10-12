#!/bin/sh
. /opt/vrdl/scripts/.env

su $VRDL_USER -c "xwininfo -display :0 -root -tree | grep -oP '\"\K[^\"]* FPS'"


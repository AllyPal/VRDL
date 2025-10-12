#!/bin/sh

## Set env vars 

. ./.env

## Func includes

. functions/prompt.sh
. functions/log.sh
. functions/setup-users.sh
. functions/setup-os-packages.sh
. functions/setup-fs.sh
. functions/setup-content.sh
. functions/setup-service.sh
. functions/setup-wine.sh

echo "|    $(date)    |" >> "$VRDL_LOG_FILE"
log 0 "Begin ..."

printf "\n"

log 0 "Setting up OS Packages ..."

if ! setup_os_packages; then
	log 2 "Failed to setup os packages"
else
	log 0 "Package setup finished"
fi

log 0 "Setting up Users ..."

if ! setup_users; then
	log 2 "Failed to setup users"
else
	log 0 "User setup finished"
fi

log 0 "Setting up filesystem ..."

if ! setup_fs; then
	log 2 "Failed to setup file system"
else
	log 0 "Filesystem setup finished"
fi

response=$(prompt "Install Content?")
if [ $response = 'y' ]; then	
	log 0 "Setting up content ..."
	
	if ! setup_content; then
		log 2 "Failed to setup content"
	else
		log 0 "Content setup finished"
	fi
else
	log 1 "Content will not be installed"	
fi	

if ! setup_wine; then
	log 2 "Failed to setup wine"
else
	log 0 "Wine setup finished"
fi

if ! setup_service; then
	log 2 "Failed to setup systemd service"
else
	log 0 "Systemd service setup finished"
fi

### Finalize


## Band-aid fix; dedi auto process needs at least one profile to exist
# or profile selection is presented

log 0 "Creating null_prf.ini to fix automation bug ..."
scctv_profile_dir="$VRDL_WINE_PREFIX_PATH/drive_c/ProgramData/Ubisoft/Tom Clancy's Splinter Cell Chaos Theory/Saved Games/Versus"
su "$VRDL_USER" -c "mkdir -p \"$scctv_profile_dir\""
su "$VRDL_USER" -c "touch \"$scctv_profile_dir\"/null_prf.ini"

## Ensure dirs owned by standard user

chown "$VRDL_USER":"$VRDL_USER" "$VRDL_BASE_PATH" -R

## Reboot

echo "A reboot is recommended"
result_rb=$(prompt "Reboot now?")

log 0 "Finished!"

if [ $result_rb = "y" ]; then
	echo "Rebooting ..."
	sleep 2
	reboot
fi


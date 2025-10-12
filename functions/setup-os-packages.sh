setup_os_packages() {
	log 0 "Adding i386 repositories via dpkg ..."
	dpkg --add-architecture i386

	log 0 "Running apt update ..."
	apt update 

	if [ $? = 0 ]; then
		log 0 "Apt update success"
	else
		log 2 "Apt update failure"
	fi

	log 0 "Running apt upgrade ..."

	apt upgrade -y

	if [ $? = 0 ]; then
		log 0 "Apt upgrade success"
	else
		log 2 "Apt upgrade failure"
	fi

	## Install Deps

	log 0 "Installing deps: $VRDL_DEPS ..."

	apt install -y $VRDL_DEPS

	if [ $? = 0 ]; then
		log 0 "Deps installation success"
	else
		log 2 "Deps installation failure"
	fi

	if [ "$VRDL_GDRIVE_SUPPORT_ENABLE" = "1" ]; then
		PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install gdown	
	fi

	## Disable unattended upgrades

	response=$(prompt "Remove apt unattended upgrades?")
	if [ $response = "y" ]; then
		log 0 "Removing unattended-upgrades ..."
		apt remove unattended-upgrades -y
	fi

	return 0
}


setup_service() {

	## Systemd service creation

	vrdl_start_basename=${VRDL_START%.*}
	vrdl_runner_basename=${VRDL_RUNNER%.*}

	service_content=$(cat <<-EOF
		[Unit]
		Description=Service for starting and starting SCCT:V R/E Dedicated Servers
		BindsTo=default.target
		Wants=default.target
		After=default.target

		[Service]
		Type=simple
		User=$VRDL_USER
		ExecStart=$vrdl_start_basename
		ExecStop=pkill sway
		ExecStop=pkill $vrdl_runner_basename
		PAMName=Login
		Restart=on-failure
		RestartSec=1
		TimeoutStopSec=10
		KillMode=control-group

		[Install]
		WantedBy=default.target
	EOF
	)

	# Remove existing service if found
	if [ -e "/etc/systemd/system/$VRDL_SERVICE_NAME.service" ]; then
		log 0 "Removing old existing services ..."
		systemctl stop "$VRDL_SERVICE_NAME"
		systemctl disable "$VRDL_SERVICE_NAME"
		rm "/etc/systemd/system/$VRDL_SERVICE_NAME.service"

		if [ ! $? -eq 0 ]; then
			log 2 "Failed to remove old systemd service"
		fi
	fi

	log 0 "Creating Systemd service ..."
	
	echo "$service_content" > "/etc/systemd/system/${VRDL_SERVICE_NAME}.service"
	
	log 0 "Reloading Systemd service daemon ..."
	systemctl daemon-reload

	if [ ! $? -eq 0 ]; then
		log 2 "Failed to reload systemd daemon"
	fi

	# Enable systemd service

	response=$(prompt "Enable systemd service (auto start on boot)?")

	if [ $response = "y" ]; then
		log 0 "Enabling Service ..."
		systemctl enable "$VRDL_SERVICE_NAME"

		if [ ! $? -eq 0 ]; then
			log 2 "Failed to enable systemd service"
		fi
	fi

	return 0	
}

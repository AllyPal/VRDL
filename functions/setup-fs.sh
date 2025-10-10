## Create Dirs
setup_fs() {
	if [ ! -e "$VRDL_BASE_PATH" ]; then
		mkdir "$VRDL_BASE_PATH"
	fi
	
	if [ ! -e "$VRDL_GAME_BASE_PATH" ]; then
		mkdir "$VRDL_GAME_BASE_PATH"
	fi
	
	if [ ! -e "$VRDL_GAME_DEFAULT_PATH" ]; then
		mkdir "$VRDL_GAME_DEFAULT_PATH"
	fi
	
	if [ ! -e "$VRDL_SCRIPTS_PATH" ]; then
		mkdir "$VRDL_SCRIPTS_PATH"
	fi
	
	
	## Copy runtime scripts to script path

	runtime_dir="runtime"

	cp "$runtime_dir/"* "$VRDL_SCRIPTS_PATH"
	
	chown "$VRDL_STANDARD_USER":"$VRDL_STANDARD_USER" "$VRDL_BASE_PATH" -R
	
	# link to bin for convenience and ommit extension (for convenience)
	if [ ! -e "/usr/local/bin/$VRDL_STATUS" ]; then
		ln "$VRDL_SCRIPTS_PATH/$VRDL_STATUS" "/usr/local/bin/${VRDL_STATUS%.*}"
	fi
	
	if [ ! -e "/usr/local/bin/$VRDL_MONITOR" ]; then
		ln "$VRDL_SCRIPTS_PATH/$VRDL_MONITOR" "/usr/local/bin/${VRDL_MONITOR%.*}"
	fi

	if [ ! -e "/usr/local/bin/$VRDL_START" ]; then
		ln "$VRDL_SCRIPTS_PATH/$VRDL_START" "/usr/local/bin/${VRDL_START%.*}"
	fi

	if [ ! -e "/usr/local/bin/$VRDL_INIT_DISPLAY" ]; then
		ln "$VRDL_SCRIPTS_PATH/$VRDL_INIT_DISPLAY" "/usr/local/bin/${VRDL_INIT_DISPLAY%.*}"
	fi

	if [ ! -e "/usr/local/bin/$VRDL_RUNNER" ]; then
		ln "$VRDL_SCRIPTS_PATH/$VRDL_RUNNER" "/usr/local/bin/${VRDL_RUNNER%.*}"
	fi
}

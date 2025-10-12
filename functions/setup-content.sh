setup_content() {
	## Acquire Game Content

	tempdir=temp
	tempdir_x="$tempdir/extracted"
	mkdir "$tempdir_x" -p

	if [ "$VRDL_LATEST_CONTENT_ENABLE" -eq 1 ] && [ ! -z "$VRDL_LATEST_CONTENT_URI" ]; then
		log 0 "Downloading latest Enhanced Version ..."
	
		content_uri=$(curl -s "$VRDL_LATEST_CONTENT_URI" \
				| jq -r ".. | .browser_download_url? // empty" | grep -vi "extended")
	
		wget "$content_uri" -P "$tempdir"

	elif [ ! -z $VRDL_STATIC_CONTENT_URI ]; then

	   	if [ "$VRDL_STATIC_CONTENT_URI" != "${VRDL_STATIC_CONTENT_URI#*drive.google}" ] && [ "$VRDL_GDRIVE_SUPPORT_ENABLE" = "1" ]; then
			log 0 "Downloading game package from GDrive at: $VRDL_STATIC_CONTENT_URI ..."
			gdown "$VRDL_STATIC_CONTENT_URI" -O "$tempdir/content.7z"
		else
			log 0 "Downloading game package at: $VRDL_STATIC_CONTENT_URI ..."
			wget "$VRDL_STATIC_CONTENT_URI" -P "$tempdir"
		fi
	else
		log 2 "VRDL_LATEST_CONTENT_URI or VRDL_STATIC_CONTENT_URI must be set in .env"
		return 0
	fi

	# Extract

	package_content="$(ls "$tempdir"/*.7z)"

	7z x -o"$tempdir_x" "$package_content" -y
	
	# If parent dir, copy from inside parent dir, else copy all files in archive root
	dirs=$(find "$tempdir_x" -mindepth 1 -maxdepth 1 -type d | wc -l)
	if [ "$dirs" -eq 1 ]; then
		dir=$(find "$tempdir_x" -mindepth 1 -maxdepth 1 -type d)
		cp "$dir"/* -r "$VRDL_GAME_DEFAULT_PATH"
	else
		cp "$tempdir_x"/* -r "$VRDL_GAME_DEFAULT_PATH"
	fi

	# Prepare for retrieving dedi support package
	rm -r "$tempdir"/*
	mkdir "$tempdir_x"

	# If provided dedicated support URI, download and install it

	if [ ! -z "$VRDL_SUPPORT_URI" ]; then
	   	if [ "$VRDL_SUPPORT_URI" != "${VRDL_SUPPORT_URI#*drive.google}" ] && [ "$VRDL_GDRIVE_SUPPORT_ENABLE" = "1" ]; then
			log 0 "Downloading dedi support package from GDrive at: $VRDL_SUPPORT_URI"
			gdown "$VRDL_SUPPORT_URI" -O "$tempdir/dedi_support.7z"
		else
			log 0 "Downloading dedi support package at: $VRDL_SUPPORT_URI"
			wget -P "$tempdir" "$VRDL_SUPPORT_URI"
		fi
		
		package_dedi="$(ls "$tempdir"/*.7z)"
		7z x -o"$tempdir_x" "$package_dedi" -y
	
		# If parent dir, copy from inside parent dir, else copy files from archive root
		dirs=$(find "$tempdir_x" -mindepth 1 -maxdepth 1 -type d | wc -l)
		if [ "$dirs" -eq 1 ]; then
			dir=$(find "$tempdir_x" -mindepth 1 -maxdepth 1 -type d)
			cp "$dir"/* -r "$VRDL_GAME_DEFAULT_PATH/System"
		else
			cp "$tempdir_x"/* -r "$VRDL_GAME_DEFAULT_PATH/System"
		fi

	fi

	# Cleanup
	
	rm -r $tempdir

	return 0
}

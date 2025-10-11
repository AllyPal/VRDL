setup_wine() {
	## Provision default wine prefix

	log 0 "Provisioning default wine prefix for $VRDL_STANDARD_USER ..."
	if [ -e "$VRDL_WINE_PREFIX_PATH" ]; then
    	log 0 "Wine prefix  already exists ..."
	else
    	su $VRDL_STANDARD_USER -c "WINEPREFIX=\"$VRDL_WINE_PREFIX_PATH\" WINEDEBUG=-all wineboot -i 2>/dev/null"
	fi

	if [ ! -e "$VRDL_WINE_PREFIX_PATH" ]; then
   		log 2 "Failed to create default wine prefix" 
	    log 2 "Exiting ..."
    	return 1
	fi

	return 0
}

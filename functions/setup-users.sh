setup_users() {
	## Create Standard User

	if id "$VRDL_USER" >/dev/null 2>&1; then
		log 0 "Standard user "$VRDL_USER" already exists"
		return 0	
	else
		log 0 "Adding user: $VRDL_USER ..."
	
		useradd "$VRDL_USER" -m # -m home dir benefits certain processes, such as font cache
		log 0 "Standard User Provisioned"
	fi

	if ! id "$VRDL_USER" >/dev/null 2>&1; then
		log 2 "Failed to add user"
		return 1
	fi

}

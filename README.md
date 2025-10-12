# VRDL - Versus Reloaded Dedicated Linux

Sets up device to work as dedicated server for Splinter Cell Chaos Theory Versus.

The dedicated server instance(s) runs underneath headless Sway and Xwayland.

- Updates server during install process
- Offers to disable unattended updates from Apt
- Creates standard user 
- Installs required dependancies
- Optionally downloads game content (must provide URI to content in .env)
- Creates systemd services to start server instances on boot
- Configures 1x1 virtual display in Sway (this seems to work, and lowers memory footprint)
- Provides status script to output the window title of the dedicated server cmd window (holds fps and player count stat)
- Provides monitor script to "watch" the status script

**Note**: The automation of content retrieval currently relies on [SCCT:V Enhanced](https://github.com/Joshhhuaaa/EnhancedSCCTVersus) packages.

## Configuration

Look to env vars in .env

VRDL_USER: Created if does not exist, service user, owner of all content at VRDL_BASE_PATH, some runtime scripts run as this user

VRDL_LATEST_CONTENT_ENABLE: Enables retrieval of latest Enhanced version via Github API

VRDL_LATEST_CONTENT_URI: API endpoint location for retrieving latest content

VRDL_STATIC_CONTENT_URI: Location of content package. Used if latest content not enabled (expects .7z)

VRDL_SUPPORT_URI: Location of dedicated server support package to install (expects .7z)

# Install

As root:

```./install.sh```

## Run

A systemd service is created to handle starting and stopping server instances.  

**Start**: systemctl start vrdl  
**Stop**: systemctl stop vrdl  

**Enable Startup**: systemctl enable vrdl  
**Disable Startup**: systemctl disable vrdl  


The **vrdl-runner** script currently handles configuration and running of individual server instances.

Edit the "servers" list in **vrdl-runner** to add or remove server instances that will be started.
Each line should be a command as if handed to Windows CMD. Use existing entries to model additional entries.

**Note:** You must ensure port numbers are not shared between server instances, otherwise they will not start properly.

**vrdl-status** and **vrdl-monitor** can be ran by calling their name from any path.

## Update

To update the server and content, simply run install.sh again.

## Support

Reloaded: 3.0+  
Enhanced: 3.6+  

Currently only supports Ubuntu Server 24.04


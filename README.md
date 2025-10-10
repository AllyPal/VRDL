
# Purpose

Sets up device to work as dedicated server for Splinter Cell Chaos Theory Versus.

# Configuration

Look to env vars in .env

# Install

as root:

```./vrdl-install```

# Run

A systemd service is created to handle starting and stopping server instances.

The "vrdl-runner" script currently handles configuration and running of individual server instances.

Edit the "servers" list in vrdl-runner to add or remove server instances that will be started by vrdl-runner.
Each line should be a command as if handed to Windows CMD. Use existing entries to model additional entries.

# What the script does

The dedicated server instance(s) runs underneath headless Sway and Xwayland.

- Updates server
- Creates standard user 
- Installs required dependancies
- Downloads game content (must provide URI to content in .env)
- Creates systemd services to start server instances on boot
- Configures 1x1 virtual display in Sway (this seems to work, and lowers memory footprint)
- Provides status script to output the window title of the dedicated server cmd window (holds fps and player count stat)
- Provides monitor script to "watch" the status script

# Support

Currently only supports Ubuntu Server 24.04


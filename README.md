# SSH Chroot jail setup script

Sets up ssh jail automatically. 
Warning: After launching the script do not forget to edit your sshd config file
to add the ChrootDirectory option


### Example: 

<p>Match User guest<br> 
Chroot Directory /jail/guest/ 
Match all</p>


After the configuration restart the ssh server on systemd by typing `sudo systemctl restart sshd`

This allow user guest to be run only in the chroot environment
Additionally it is possible to allow the sftp command by changing Subsystem to
`Subsystem sftp internal-sftp` 

## Configuration
`CFG_USERNAME` Name of the user that will be locked in the chroot environment \
`CFG_USERSHELL` A default shell that the user can access in chroot (need to specify full path) \
`CFG_JAILDIR` A directory where user will be chrooted \
`CFG_HOME_PERMISSION` Access to the chroot directory (default 700, only the created user can access the directory) \
`CFG_DEFAULT_PROGS` A list of programs separated by a whitespace that the user can access. To add more programs please refer to the addtojail.sh documentation


## Adding programs to the jail
run the `addtojail.sh` script. The first argument is the path to the jail directory. All of the other arguments are the names of the programs which will be added. The program needs to be in the PATH variable


## Installation (Linux)
`cd path_to_the_folder` \
`chmod +x sshjail_setup.sh` \
`chmod +x addtojail.sh` 


## Uninstallation
Remove the chroot directory eg. `sudo rm -rf /jail` 
Delete the user and his home directory `sudo userdel guest 
Optionally the guests home directory can be removed. Make sure to backup all important files and run
`sudo rm -rf /home/guest` 

## Tested platform
Arch Linux: linux-6.0.12-zen1-1-zen, Openssh 9

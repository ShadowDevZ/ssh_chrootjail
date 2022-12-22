#! /bin/bash
# Setups ssh chroot jail environment
#
# exit on error
set -e

if [ "$EUID" -ne 0 ]
then echo $0 needs to be run as root
    exit -1
fi



###CONFIG START###
CFG_USERNAME="guest"
CFG_USERSHELL="/bin/bash"
CFG_JAILDIR="/jail/guest"
CFG_HOME_PERMISSION=700
#!!! TO ADD MULTIPLE PROGRAMS RUN addtojail.sh script!!!
CFG_DEFAULT_PROGS="bash ls grep"
###CONFIG END###

echo "----------------------------------"
echo "Username:     $CFG_USERNAME"
echo "Shell:        $CFG_USERSHELL"
echo "Chroot dir:   $CFG_JAILDIR"
echo "Programs:     $CFG_DEFAULT_PROGS"
echo "Home permissions $CFG_HOME_PERMISSION"
echo "----------------------------------"
read -p "Proceed ? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ok
else
    echo exiting...
    exit
fi

echo "Adding user $CFG_USERNAME"
useradd -m guest
echo "Please enter password for $CFG_USERNAME"
passwd $CFG_USERNAME
echo "Changing shell for $CFG_USERNAME"
chsh -s $CFG_USERSHELL $CFG_USERNAME
echo "Creating $CFG_JAILDIR"
mkdir -pv $CFG_JAILDIR
chown -v root:root $CFG_JAILDIR
echo "Creating user's directory"
mkdir -pv $CFG_JAILDIR/home
chown -Rv $CFG_USERNAME:$CFG_USERNAME $CFG_JAILDIR/home
chmod -Rv $CFG_HOME_PERMISSION $CFG_JAILDIR/home
mkdir -pv $CFG_JAILDIR/{dev,usr}
mkdir -pv $CFG_JAILDIR/usr/{bin,lib,lib64}
cp -v --parents /etc/{passwd,group} $CFG_JAILDIR
echo "Creating devices..."
mknod -m 666 $CFG_JAILDIR/dev/null c 1 3
mknod -m 666 $CFG_JAILDIR/dev/random c 1 8
mknod -m 666 $CFG_JAILDIR/dev/tty c 5 0
mknod -m 666 $CFG_JAILDIR/dev/zero c 1 5
echo "Creating symlinks..."
ln -sv /proc/self/fd/2 $CFG_JAILDIR/dev/stderr
ln -sv /proc/self/fd/0 $CFG_JAILDIR/dev/stdin
ln -sv /proc/self/fd/1 $CFG_JAILDIR/dev/stdout
#
bash -c "cd $CFG_JAILDIR && ln -sv usr/bin bin"
bash -c "cd $CFG_JAILDIR && ln -sv usr/lib lib"
bash -c "cd $CFG_JAILDIR && ln -sv usr/lib64 lib64"
#ln -sv $CFG_JAILDIR/usr/lib $CFG_JAILDIR/lib
#ln -sv $CFG_JAILDIR/usr/lib64 $CFG_JAILDIR/lib64
bash ./addtojail.sh $CFG_JAILDIR $CFG_DEFAULT_PROGS
echo
echo done




#! /bin/bash
set -e
if [ $# -le 1 ]
then
    echo "Usage [JAIL_DIR] [PROGRAM] ..."
    exit -1
fi

#PROGRAM=$(which $1)
JAIL_DIR="$1"
#DEPS=$(ldd $PROGRAM | awk '{print $3}')
#cp -v --parents $DEPS $JAIL_DIR
#cp -v $PROGRAM $JAIL_DIR/bin
for PROGRAM in ${*:2}
do
    echo Copying $PROGRAM
    
    PROGRAM=$(which $PROGRAM)
    DEPS=$(ldd $PROGRAM | awk '{print $3}')
    
    cp --parents $DEPS $JAIL_DIR
    cp -v $PROGRAM $JAIL_DIR/bin/$(basename $PROGRAM)

done
#cp -v --parents $PROGRAM $JAIL_DIR

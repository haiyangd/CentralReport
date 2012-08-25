#!/bin/bash

# CentralReport Unix/Linux installer.
# For CentralReport Indev version.
# By careful! Don't use in production environment!

# Importing scripts...
source bash/common_functions.sh
source bash/installer_macos.sh

# Vars
ACTUAL_MODE=install                         # Modes : install, check
PARENT_DIR=/usr/local/bin/
INSTALL_DIR=/usr/local/bin/centralreport
CONFIG_FILE=/etc/cr/centralreport.cfg
PID_FILE=/tmp/daemon-centralreport.pid
STARTUP_PLIST=/Library/LaunchDaemons/com.centralreport.plist
STARTUP_PLIST_INSTALL=lunchers/com.centralreport.plist

# Temp install directories.
CHERRYPY_TAR=thirdparties/CherryPy.tar.gz
MAKO_TAR=thirdparties/Mako.tar.gz

CHERRYPY_DIR=thirdparties/CherryPy-3.2.2
MAKO_DIR=thirdparties/Mako-0.7.2


# Go!

echo -e "\033[44m\033[1;37m"
echo -e "  -------------- CentralReport installer --------------\033[0;44m"
echo " "
echo "  Welcome! This script will install CentralReport on your host."
echo "  If you wants more details, please visit http://github.com/miniche/CentralReport."
echo " "
echo " During installation, we can ask an administrator password. It permit CentralReport "
echo " to write in some directories and remove old CR installations."
echo -e "\033[0m"

# In the future, it will possible to have different modes.
if [ -n "$1" ]; then
    ACTUAL_MODE=$1
fi

# Getting current OS - from common_functions.sh
getOS

# Check the actual mode.
if [ ${ACTUAL_MODE} == "install" ]; then

    # Right now, it only works on MacOS.
    # Support for Linux distrib coming soon.
    if [ "$CURRENT_OS" != "$OS_MAC" ]; then
        echo " "
        echo -e "\033[1;31mERROR"
        echo -e "\033[0;31mThe install is only design for Mac OS"
        echo -e "Linux support coming soon! \033[0m"
    else

        echo " "
        echo "Install mode enabled"
        echo "You will install CentralReport. Are you sure to continue? (Yes/No)"
        read

        # Are you sure to install CR ?
        if [ $REPLY == "yes" ]; then

            # It's an indev version. At each install, we delete everything.

            if [ ${CURRENT_OS} == "$OS_MAC" ]; then
                echo "Ok, I continue. I will install CentralReport on a mac"

                install_on_macos
            fi


            # Done ! We can starting CentralReport!


            echo " "
            echo " ** Starting CentralReport... ** "
            sudo python ${INSTALL_DIR}/run.py start

            echo " "
            echo "Please wait before the first check..."

            sleep 3;

            echo -e "\033[1;32m"
            echo " "
            echo "CentralReport might be installed!"
            echo "You can go to http://127.0.0.1:8080 to display the web view"
            echo "or you can edit the config file at /etc/cr/centralreport.cfg"
            echo " "
            echo "More help at http://github.com/miniche/CentralReport"
            echo "Have fun!"
            echo " "
            echo -e "\033[0m"

        fi

    fi

else
    echo " "
    echo "ERROR!"
    echo "Unknown argument"
    echo "Use : install.sh [install]"
fi


# End of program
echo " "
echo " -- End of program -- "
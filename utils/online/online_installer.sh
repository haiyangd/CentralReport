#!/bin/bash

# ------------------------------------------------------------
# CentralReport Unix/Linux online installer
# Alpha version. Don't use in production environment!
# ------------------------------------------------------------
# https://github.com/CentralReport
# ------------------------------------------------------------

# This script will download the latest CentralReport installer and processes the install
# It works for Mac OS X, Debian and Ubuntu
# Enjoy!

# Vars
URL_CR="http://static.centralreport.net/cr_installer.tar.gz"
ARCHIVE="cr_installer.tar.gz"
DIR="CentralReportInstaller"

CURRENT_OS=""
OS_MAC="MacOS"
OS_DEBIAN="Debian"
OS_CENTOS="CentOS"

# TODO: Find a more accurate word than "online"
echo -e "\n\nWelcome to CentralReport online installer!"

# Getting current OS
if [ "Darwin" == $(uname -s) ]; then
    # Mac OS X
    CURRENT_OS=${OS_MAC}
elif [ -f "/etc/debian_version" ] || [ -f "/etc/lsb-release" ]; then
    # Debian or Ubuntu
    CURRENT_OS=${OS_DEBIAN}
elif [ -f "/etc/redhat-release" ]; then
    cat /etc/redhat-release | grep "CentOS" &>/dev/null
    if [ "$?" -eq 0 ]; then
        CURRENT_OS=${OS_CENTOS}
    fi
fi

if [ "${CURRENT_OS}" == "" ]; then
    echo " "
    echo "Sorry, your OS isn't supported yet..."
    exit 1
fi

echo -e "\nChecking Python availability on your host..."
python -V
if [ $? -ne 0 ]; then
    echo -e "\n\nError, Python must be installed on your host to execute CentralReport."
    exit 1
fi

if [ "${CURRENT_OS}" == "${OS_DEBIAN}" ] || [ "${CURRENT_OS}" == "${OS_CENTOS}" ]; then
    if [[ $EUID -ne 0 ]]; then
        echo " "
        echo "You must be root to run CentralReport installer!"
        exit 2
    fi
fi

echo -e "\nDownloading the installer..."
cd /tmp
if [ ${CURRENT_OS} = ${OS_MAC} ]; then
    curl -O ${URL_CR}
else
    wget -q ${URL_CR}
fi

if [ ! -f ${ARCHIVE} ]; then
    echo -e "\n\nError downloading the CentralReport installer!"
    exit 3
fi

echo -e "\nUnpackaging the installer..."
tar -xzf ${ARCHIVE}

cd ${DIR}
chmod +x install.sh

echo -e "\nLaunching the installer..."
./install.sh

echo -e "\nRemoving all temporary files"
cd ../
rm -R ${DIR}
rm ${ARCHIVE}

# Done !
exit 0

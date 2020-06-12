#!/bin/bash

# CROSS LOUGH SOFTWARE
# infChat Build Script
# Authors: lordfeck
# Authored: 21/05/2020

echo "Checking your environment for prerequisites to run infChat."

# Likely needs SQlite, perl and some modules.

echo "This script will answer the question: Is your system Golden or Dud? This script will do all it can to remedy a dud."

mode="live"
doPortCheck="y"
nginxIsInstalled="idk_yet"
docker="false"

readonly banner="USAGE: ./$0 [args]\nRun with no flags to perform a full live install. Requires root privileges.
ARGS:\n-h print this message.\n-w copy WWW and CGI only, no root required. Use this to update a ready-existing installation.
-c Check only; will not modify your system. Will check whether requirements are met, report and exit.\n-u <login> Set your username to <login>.
-o copy config only.\n-p Skip port check. Useful if you already have Nginx installed.\n-d perform dev mode install (for local dev env only).
-D using this script inside Docker."

function set_dev
{
    mode="dev"
    userName="$devUserName"
    htmlRoot="$devRoot"
    # Used in sed
    wwwRoot="$devSedRoot"
}

function check_ports
{
    local netStOut="$( netstat -nl )"

    if echo $netStOut | grep -Eq '(0.0.0.0:)((80)|(443))\b' --color ; then
        echo "Services already found running on either ports 80 or 443. These are required for nginx HTTP and HTTPS."
        exit 1
    else
        echo "Ports 80 and 443 are available. Continuing..."
    fi
}

function check_os
{
    opsys=$(lsb_release -is)
    echo "Detected OS: ${opsys}"
    if [ "$opsys" = "Ubuntu" ] || [ "$opsys" = "Debian" ]; then
        echo "Using APT and DPKG for Debian and sons."
        packager="apt-get -qy install"
        query="dpkg -s"
    elif [ "$opsys" = "CentOS" ]; then
        packager="yum -qy install"
        query="rpm -q"
    else
        echo "DUD: Only Debian, Ubuntu or CentOS packagers are supported. Manual install is still possible."
        echo "Please install $dependencies from your system's packager and copy the www-source manually."
        exit 1
    fi
}

function create_dirs
{
    echo "Creating directory for HTML."
    mkdir -p $htmlRoot
    echo "Setting ownership for $userName on $rootDir."
    chown -R $userName $htmlRoot
}

function copy_html
{
    echo "Copying HTML into $htmlRoot."
    cp -rfv ../www-static/* $htmlRoot
}

function copy_config
{
    echo "Copying config to $nginxConfigDir."
    cp -fv ../nginx-config/nginx.conf $nginxConfigDir
    cp -fv ../nginx-config/infChat $nginxConfigDir/sites-available/
    rm -r /etc/nginx/sites-enabled/default
}

function edit_config
{
    echo "Editing config files in $nginxConfigDir with correct WWWroot."
    sed -i "s/##WWWROOT##/$wwwSedRoot/g" $nginxConfigDir/sites-available/infChat
    ln -s "$nginxConfigDir/sites-available/infChat" "$nginxConfigDir/sites-enabled/infChat"
}

function check_nginx_install
{
    if ! 2>&1 $query $dependencies >/dev/null; then
        echo "DUD: Any of $dependencies are not installed!"
        nginxIsInstalled="no"
    else
        echo "GOLDEN: All requisite dependencies are installed. Continuing..."
    fi
}

function install_nginx
{
    echo "Installing nginx and all dependencies..."
    2>&1 $packager $dependencies >/dev/null
}

# Works on Debian, Ubuntu and derivatives. SystemD or Init.
function restart_nginx
{
    echo "Restarting Nginx..."
    service nginx restart
}

function check_privileges
{
    if [ $(id -u) -ne "0" ]; then
        echo "DUD: Please run as root or sudo."
        exit 1
    fi
}

function docker_wait
{
	echo "In docker mode, waiting for SIGTERM."
	tail -f /dev/null
}

# Begin main body of script

if [ ! -s "setup.local" ]; then
    echo "DUD: setup.local file missing or empty, cannot continue."
    echo "Please copy setup.config, name it setup.local and edit it to match your environment."
    exit 1
fi
. setup.local

while getopts ":hdwopu:cD" opt; do
    case $opt in
        "h" ) echo -e "$banner"; exit 0 ;;
        "d" ) set_dev ;;
        "w" ) copy_html; exit 0 ;;
        "o" ) check_privileges
              copy_config
              edit_config
              restart_nginx
              exit 0 ;;
        "p" ) doPortCheck="n" ;;
        "u" ) userName="$OPTARG" ;;
	"D" ) docker="true" ;;
	"c" ) checkOnly="true" ;;
        * ) echo -e "Invalid Args.\n\n$banner"; exit 1 ;;
    esac
done

# Now run with configured options
echo "Beginning infChat $mode checks..."

[ "$checkOnly" = "true" ] || check_privileges
check_os
if [ "$doPortCheck" = "y" ]; then
    check_ports
else
    echo "Skipping port check."
fi
check_nginx_install

[ "$checkOnly" = "true" ] && exit 0

echo "Now beginning installation."
if [ "$nginxIsInstalled" = "no" ]; then
    install_nginx
fi
copy_config
edit_config
create_dirs
copy_html
restart_nginx

[ "$docker" = "true" ] && docker_wait

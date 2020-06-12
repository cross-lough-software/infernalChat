# Environment check and setup

*This script is optional,* but in the right hands it will make life easy.

Builds a server from scratch. Tested on Debian and Ubuntu systems; may also work on CentOS.

## Requirements
Requires the BASH shell, nginx, fcgiwrap, and a number of Perl modules to function fully. Check  the *dependencies* variable inside `setup.config`.

## Important - before using

Copy `setup.config` and rename it `setup.local`.

Edit `setup.local` to match your environment.

**note:** This is done to avoid clashes with version control.

## Script Features

### createEnv.sh

This script will fully install a infernalChat environment.

* Check that ports 80 and 443 is free.
* Setup Nginx (if not already installed)
* Installs fcgiwrap.
* Create dirs for both HTML and scripts, then copies these across.
* Install nginx config.
* Launch the server.

**Usage**

Run `./createEnv.sh -d` to setup on a "dev" environment. This setup method uses your login name and other params relevant to the local developer's machine.

Call `./createEnv.sh -h` to see all setup options listed.

The script should be run either with `sudo` or using `root`.

### Functional Notes & Assumptions

Links with the same `../infChat/` directory. From here are copied the infChat Perl Scripts to the correct www-root.

Assumes that `../www-root/` and `../nginx-config/` are where they should be. If run from a checked-out repo, this will be fine.

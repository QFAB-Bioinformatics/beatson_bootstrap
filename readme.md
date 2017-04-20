# Beatson OS X Bootstrapper #

This collection of scripts are used to quickly set up new OS X computers in the Beatson Lab.
* Installs `tcsh` as the default shell
* Installs software managers Homebrew and Conda
* Sets OS X system settings
* Installs general software and tools using Homebrew
* Installs managed bioinformatics tool environment using Conda

## Usage ##

* Download all files to a local directory
* (Optional) edit `brew.file` and/or `osx_defaults.sh` for personal preference
* In terminal, run `bootstrap_beatson.sh`
* If prompted, restart computer


### File Information ###
* bootstrap_beatson.sh
    * the actual bootstrap script. Run this on a new computer to bootstrap.
* brew.file
    * contains the homebrew recipes and casks to install. Collection of useful command line tools and general software applications. Called from `bootstrap_beatson.sh`. Can be updated to add new programs as desired and
* conda_installer.sh
    * Used to setup the Conda environments managed in the Beatson Ansible repository. Rerun to update or replace local environments (interactive).
* osx_defaults.sh
    * a separate script that sets a number of operation system systems for improved experience. Called from `bootstrap_beatson.sh`. Edit this as desired (a number of additional tweaks are documented within and commented out by default).
* readme.md
    * this file

### Author ###
Initially developed by Thom Cuddihy (QFAB, 2017) while embedded with the Beatson Lab
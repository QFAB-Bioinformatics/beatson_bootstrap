#!/usr/bin/env bash
#
# Shell script to bootstrap Scott Beatson's laptop
#
# Actions: sets the shell as tcsh and installs Homebrew
# installs a collection of tools using Brew ('brew.file')
# sets some basic system defaults ('osx_defaults.sh')
# installs tcsh-enabled Conda ('conda_installer.sh')
# installs Beatson Lab Conda environments (see 'conda_installer.sh')

fancy_echo() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}

fancy_echo 'Please enter your password if prompted'
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
if ! command -v brew >/dev/null; then
  fancy_echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  
  # As this is a provision run, we'll clear the persistent apps on the dock
  defaults write com.apple.dock persistent-apps -array
else
  fancy_echo "Homebrew already installed. Skipping ..."
fi

fancy_echo 'Installing tcsh...'
brew install tcsh

fancy_echo 'Setting tcsh as default shell..'
chsh -s /bin/tcsh

fancy_echo 'Installing git...'
brew install git

fancy_echo 'Updating homebrew..'
brew update

fancy_echo 'Running Brew file..'
brew bundle --file=brew.file

fancy_echo 'Setting OSX defaults..'
source osx_defaults.sh

fancy_echo 'Installing Conda for tcsh..'
source conda_installer.sh

fancy_echo 'All done! Some of these changes require a restart to take effect.'

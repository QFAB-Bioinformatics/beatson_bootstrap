#!/bin/bash

# Install Conda (via Miniconda) for tcsh shells
# Author: Little Tinker/Thom Cuddihy 2017

append_to_file() {
	local FILE="${1}"
	local TEXT="${2}"

	if ! grep -qs "^${TEXT}$" "${FILE}"; then
		echo "Adding ${TEXT} to ${FILE}"
		printf "\n%s\n" "${TEXT}" >> "${FILE}"
	else
		echo "Do not need to add text to ${FILE}"
	fi
}

conda_install() {
	CONDA_URL_BASE="https://repo.continuum.io/miniconda"
	CONDA_INSTALLER="Miniconda2-latest-MacOSX-x86_64.sh"

	echo "Downloading and installing Miniconda.."
	curl ${CONDA_URL_BASE}/${CONDA_INSTALLER} > ${CONDA_INSTALLER}
	bash ${CONDA_INSTALLER}
	
	echo "Conda installed; removing installer"
	rm ${CONDA_INSTALLER}
}

conda_path() {
	echo "Please enter the full path chosen to install Conda"
	echo "(should be ${HOME}/Miniconda2 by default e.g.)"
	read INSTALL_PATH

	if [[ -f ${INSTALL_PATH}/bin/conda ]]; then
		INSTALL_PATH="${INSTALL_PATH}/bin"
	else
		# account for if the user adds 'bin'
		if [[ ! -f ${INSTALL_PATH}/conda ]]; then
			echo "Could not find the Conda executable in ${INSTALL_PATH}"
			echo "Exiting: please verify Conda location and try again"
			exit 1
		fi
	fi

	echo "Setting up PATH for Conda (tcsh)..."
	append_to_file "${HOME}/.login" 'set path = ($path ${INSTALL_PATH} . )'

	echo "Setting up PATH for Conda (bash; scripts e.g.).."
	# For some weird reason, the Conda installs its PATH
	# to ~/.bash_profile ONLY, regardless of current shell
	# (and that .bash_profile should be .bashrc)
	append_to_file "${HOME}/.bashrc" 'export PATH="${INSTALL_PATH}:$PATH"'

	echo "Conda installed and PATH setup"

	echo ""
}

conda_update() {
	RAW_CONDA_INSTALLER="https://raw.githubusercontent.com/QFAB-Bioinformatics/beatson-mgvl-ansible/master/group_vars/osx_confs/conda_bootstrap.sh"
	RAW_CONDA_YML="https://raw.githubusercontent.com/QFAB-Bioinformatics/beatson-mgvl-ansible/master/group_vars/osx_confs/osx_conda_beatson.yml"

	echo "Downloading and installing managed Conda environment"
	curl ${RAW_CONDA_INSTALLER} > $(basename ${RAW_CONDA_INSTALLER})
	curl ${RAW_CONDA_YML} > $(basename ${RAW_CONDA_YML})

	# using bash to launch a new shell (because PATH)
	bash $(basename ${RAW_CONDA_INSTALLER}) $(basename ${RAW_CONDA_YML})
}

########### Run code

if ! command -v conda >/dev/null; then
	conda_install
	conda_path
else
	echo "Conda already installed."
fi

conda_update

echo "Beatson OS X Conda installation complete"

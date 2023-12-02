#!/bin/sh
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html
# Run "source scrit.sh"

# color
# See also: ANSI escape code
# color = CSI n m
ESC="\033"
CSI="${ESC}["
RESET="${CSI}m"
BOLD="${CSI}1m"
BLINK="${CSI}5m"
FG_YELLOW="${CSI}33m"
BG_YELLOW="${CSI}43m"
FG_BG_YELLOW="${CSI}33;43m"
FG_BG_DEFAULT="${CSI}39;49m"

echo_yellow() {
	local str=$1
	echo -e ${BOLD}${FG_YELLOW}${str}${RESET}
}

echo_yellow_blink() {
	local str=$1
	echo -e ${BLINK}${FG_YELLOW}${str}${RESET}
}

export GOINFRE="/goinfre/${USER}"
BREW_DIR="${GOINFRE}/.brew"
APPLICATION="${GOINFRE}/Applications"
GH_DIR=${BREW_DIR}/Cellar/gh
CONFIG_DIR="$GOINFRE/setting/config"

fn_goinfre() {
	echo_yellow "fn_goinfre"
	mkdir -p /goinfre/mki
	ln -s /goinfre/mki ${HOME}/goinfre
}	

fn_42toolbox() {
	rm -rf ${GOINFRE}/42toolbox
	git clone https://github.com/alexandregv/42toolbox.git ${GOINFRE}/42toolbox
}

# https://docs.brew.sh/Installation
fn_brew() {
	if [[ "${PATH}" != *brew* ]]
	then
		export "PATH=${GOINFRE}/.brew/bin:${PATH}"
		echo_yellow "$BREW_DIR/bin is added in PATH"
		echo_yellow "PATH=$PATH"
	fi

	if [ -d ${BREW_DIR} ]
	then
		echo_yellow "brew is already installed"
	else
		echo_yellow "brew is installing..."
		rm -rf $BREW_DIR
		git clone --depth=1 https://github.com/Homebrew/brew $BREW_DIR
		eval "$($BREW_DIR/bin/brew shellenv)"
		brew update --force --quiet
		chmod -R go-w "$(brew --prefix)/share/zsh"
		echo_yellow "brew installed successfully"
	fi
}

# https://github.com/pyenv/pyenv
fn_brew_pyenv() {
	PYENV_DIR=${BREW_DIR}/Cellar/pyenv
	export PYENV_ROOT="${GOINFRE}/.pyenv"

	if [ -d ${PYENV_ROOT} ]
	then
		echo_yellow "pyenv is already installed"
	else
		echo_yellow "pyenv is installing..."
		rm -rf $PYENV_ROOT
		brew install xz
		brew install pyenv
		mv $HOME/.pyenv ${PYENV_ROOT}

		pyenv install 3.11
		pyenv global 3.11

		command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
		eval "$(pyenv init -)"
		echo_yellow "pyenv installed successfully"
	fi
}

fn_brew_gh() {
	if [ -d ${GH_DIR} ]
	then
		echo_yellow "gh is already installed"
	else
		brew install gh
		echo_yellow "gh installed successfully"
	fi
}

fn_brew_install_cask() {
	local cask=$1

	mkdir -p "$APPLICATION"
	
	if [ ! -d $BREW_DIR ]
	then
		ft_brew
	fi

	if [ -d ${BREW_DIR}/Caskroom/$cask ]
	then
		echo_yellow "$cask is already installed"
	else
		brew install --cask "${cask}" --appdir "$APPLICATION"
		echo_yellow "${cask} installed successfully"
	fi
}

fn_nvm() {
	export NVM_DIR="${GOINFRE}/.nvm"

	if [ -d ${GOINFRE}/.nvm ]
	then
		echo_yellow "nvm is already installed"
	else
		rm -rf ${NVM_DIR}
		mkdir -p ${NVM_DIR}
		sh -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh)"
		source ${HOME}/.zshrc
		echo_yellow "nvm installed successfully"
		nvm install --lts
		echo_yellow "node lts installed successfully"
		npm i -g yarn
		npm install -g parcel-bundler
		npm install -g typescript
	fi
}

fn_sdkman() {
    export SDKMAN_DIR="${GOINFRE}/.sdkman"

	if [ -d ${GOINFRE}/.sdkman ]
	then
		echo_yellow "sdkman is already installed"
	else
        rm -rf ${SDKMAN_DIR}
        curl -s "https://get.sdkman.io" | bash
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi
}

fn_reset() {
	touch $HOME/.reset
	touch $HOME/.reset_library
	# pkill loginwindow
}

fn_all() {
	echo_yellow "source script.sh all"
	fn_42toolbox
	fn_brew
    fn_brew_install_cask "google-chrome"
    fn_brew_install_cask "postman"
    fn_brew_install_cask "visual-studio-code"
    fn_brew_install_cask "pycharm"
	# fn_brew_pyenv
    # fn_nvm
    # fn_sdkman
}

fn_clean() {
	echo_yellow "source script.sh clean"
	rm -rf ${BREW_DIR}
	rm -rf ${PYENV_ROOT}
}

fn_clean_cache() {
	rm -rf ${HOME}/Library/Application Support/Slack
	rm -rf ${HOME}/Library/Application Support/Google/Chrome
	rm -rf ${HOME}/Library/Caches/Google
	rm -rf ${HOME}/Library/Caches/com.google.SoftwareUpdate
}

fn_fclean() {
	echo_yellow "source script.sh fclean"
	fn_clean
}

fn_re() {
	echo_yellow "source script.sh re"
	fn_fclean
	fn_all
}

fn_main() {
	if [ $1 = "--help" ]
	then
		echo_yellow "source script.sh settings"
		echo_yellow "source script.sh brew"
		echo_yellow "source script.sh pyenv"
	elif [ $1 = "42toolbox" ]
	then
		fn_42toolbox
	elif [ $1 = "brew" ]
	then
		fn_brew
	elif [ $1 = "pyenv" ]
	then
		fn_brew_pyenv
	elif [ $1 = "cask" ]
	then
		fn_brew_install_cask $2
	elif [ $1 = "sdkman" ]
	then
		fn_sdkman
	elif [ $1 = "nvm" ]
	then
		fn_nvm
	elif [ $1 = "goinfre" ]
	then
		fn_goinfre
	elif [ $1 = "all" ]
	then
		fn_all
	elif [ $1 = "clean" ]
	then
		fn_clean
	elif [ $1 = "fclean" ]
	then
		fn_fclean
	elif [ $1 = "re" ]
	then
		fn_re
	fi
	return 0
}

if [ $# -eq 0 ]
then
	echo_yellow "Usage: source script.sh --help"
	return 1
else
	fn_main $1 $2
	return 0
fi

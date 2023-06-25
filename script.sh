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
PYENV_DIR=${BREW_DIR}/Cellar/pyenv
export PYENV_ROOT="${GOINFRE}/.pyenv"

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
	if [ -d ${PYENV_DIR} ]
	then
		echo_yellow "pyenv is already installed"
	else
		echo_yellow "pyenv is installing..."
		rm -rf $BREW_DIR
		brew install xz
		brew install pyenv
		mv $HOME/.pyenv ${PYENV_ROOT}

		command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
		eval "$(pyenv init -)"

		pyenv install 3.11
		pyenv global 3.11
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
		npm i -g yarn
		npm install -g parcel-bundler
		npm install -g typescript
	fi
}

fn_reset() {
	touch $HOME/.reset
	touch $HOME/.reset_library
	# pkill loginwindow
}

fn_all() {
	echo_yellow "source script.sh all"
	fn_brew
	fn_brew_pyenv
}

fn_clean() {
	echo_yellow "source script.sh clean"
	rm -rf ${BREW_DIR}
	rm -rf ${PYENV_ROOT}
}

fn_fclean() {
	echo_yellow "source script.sh fclean"
	fn_clean
}

fn_re() {
	echo_yellow "source script.sh re"
	fn_fclean && fn_all
}

fn_main() {
	if [ $1 = "--help" ]
	then
		echo_yellow "source script.sh settings"
		echo_yellow "source script.sh brew"
		echo_yellow "source script.sh pyenv"
	elif [ $1 = "brew" ]
	then
		fn_brew
	elif [ $1 = "pyenv" ]
	then
		fn_brew_pyenv
	elif [ $1 = "visual-studio-code" ]
	then
		fn_brew_install_cask "visual-studio-code"
	elif [ $1 = "postman" ]
	then
		fn_brew_install_cask "postman"
	elif [ $1 = "firefox" ]
   	then
		fn_brew_install_cask "firefox"
	elif [ $1 = "nvm" ]
	then
		fn_nvm
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
	fn_main $1
	return 0
fi

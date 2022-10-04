#!/bin/sh
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

echo_yellow_blink() {
	local str=$1

	echo -e ${BOLD}${FG_YELLOW}${str}${RESET}
}

fn_reset() {
	touch $HOME/.reset
	touch $HOME/.reset_library
	pkill loginwindow
}

fn_export() {
	export GOINFRE="/goinfre/${USER}"
	export ZSH="${GOINFRE}/.oh-my-zsh"
	BREW_DIR="${GOINFRE}/.brew"
	APPLICATION="$GOINFRE/Applications"
}

fn_copy_config() {
	CONFIG_DIR="$GOINFRE/setting/config"
	cp $CONFIG_DIR/gitconfig $HOME/.gitconfig
	cp $CONFIG_DIR/vimrc $HOME/.vimrc
	cp $CONFIG_DIR/zshrc $HOME/.zshrc
}

fn_ohmyzsh() {
	if [ -d ${GOINFRE}/.oh-my-zsh ]
	then
		echo_yellow_blink "oh-my-zsh is already installed"
	else
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		soucre ~/.zshrc
	fi
}

fn_nvm() {
	if [ -d ${GOINFRE}/.nvm ]
	then
		echo_yellow_blink "nvm is already installed"
	else
		NVM_DIR="${GOINFRE}/.nvm"
		export NVM_DIR=${NVM_DIR}
		rm -rf ${NVM_DIR}
		mkdir -p ${NVM_DIR}
		sh -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh)"
		source ${HOME}/.zshrc
		echo_yellow_blink "nvm installed successfully"
		nvm install --lts
		npm i -g yarn
		npm install -g parcel-bundler
		npm install -g typescript
	fi
}

fn_brew() {

	if [[ "${PATH}" != *brew* ]]
	then
		export "PATH=${GOINFRE}/.brew/bin:${PATH}"
		echo_yellow_blink "$BREW_DIR/bin is added in PATH"
		echo_yellow_blink "PATH=$PATH"
	fi

	if [ -d ${BREW_DIR} ]
	then
		echo_yellow_blink "brew is already installed"
	else
		rm -rf $GOINFRE/.brew && git clone --depth=1 https://github.com/Homebrew/brew $GOINFRE/.brew && brew update
		echo_yellow_blink "brew installed successfully"
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
		echo_yellow_blink "$cask is already installed"
	else
		brew install --cask "${cask}" --appdir "$APPLICATION"
		echo_yellow_blink "${cask} installed successfully"
	fi
}

fn_main() {
	fn_export
	fn_copy_config

	if [ $1 = "--help" ]
	then
		echo_yellow_blink "all: setup all"
		echo_yellow_blink "oh-my-zsh: setup"
	elif [ $1 = "reset" ]
	then
		fn_reset
	elif [ $1 = "all" ]
	then
		fn_ohmyzsh
		fn_nvm
		fn_brew
		fn_brew_install_cask "visual-studio-code"
		fn_brew_install_cask "postman"
		fn_brew_install_cask "firefox"
	elif [ $1 = "oh-my-zsh" ]
	then
		fn_ohmyzsh
	elif [ $1 = "nvm" ]
	then
		fn_copy_config
		fn_nvm
	elif [ $1 = "brew" ]
	then
		fn_brew
	elif [ $1 = "visual-studio-code" ]
	then
		fn_brew_install_cask "visual-studio-code"
	elif [ $1 = "postman" ]
	then
		fn_brew_install_cask "postman"
	elif [ $1 = "firefox" ]
   	then
		fn_brew_install_cask "firefox"
	fi
	return 0
}

if [ $# -eq 0 ]
then
	echo_yellow_blink "Usage: source script.sh [ --help | oh-my-zsh | .. ]"
	return 1
else
	fn_main $1
	return 0
fi

MAKEFLAGS += --silent

all: init softwareupdate brew install
	echo ":: Done ::"

init:
	echo "You are about to install BM helper tools on your mac."
	echo "Are you sure? (Press Enter to continue or Ctrl+C to abort) "
	read _

brew:
	echo ":: $@ :: "
	which brew &>/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle install
	brew cu

softwareupdate:	
	echo ":: $@ :: "
	touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
	softwareupdate -i -a
	rm -rf /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
	
install:
	echo ":: $@ :: "
	if [ ! -f "$(HOME)/.ssh/id_rsa" ]; then ssh-keygen -t rsa; fi 
	pip3 install -U -r requirements.txt
	git config --global --add safe.directory '*'
	akamai install terraform
	install -v envrc $(HOME)/.envrc
	install -d $(HOME)/bin
	install -v terraform.sh $(HOME)/bin/terraform.sh
	install -d $(HOME)/.terraform.d/plugin-cache
	install -v terraformrc $(HOME)/.terraformrc
	install -v aliases.zsh $(HOME)/.oh-my-zsh/custom/aliases.zsh
	install -d $(HOME)/.zcli
	install -v zscaler_root.pem $(HOME)/.zcli/zscaler_root.pem

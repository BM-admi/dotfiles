brew:
	brew bundle install
	brew cu

softwareupdate:	
	touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
	softwareupdate -i -a
	rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
	
install-configs:
	install -v gitconfig $(HOME)/.gitconfig	
	install -v envrc $(HOME)/.envrc
	install -v aliases.zsh $(HOME)/.oh-my-zsh/custom/aliases.zsh
	install -v zscaler_root.pem $(HOME)/.zcli/zscaler_root.pem
	

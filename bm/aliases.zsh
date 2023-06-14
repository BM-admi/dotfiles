# $HOME/.oh-my-zsh/custom/aliases.zsh
alias g='git'
alias gdba='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias tree='tree --gitignore'
alias python='python3'
alias p='python3'
alias t='terraform'
alias tf='terraform'
alias tfvalidate='tf validate'
alias tffmt='tf fmt'
alias tfinit='tf init -upgrade -reconfigure'
alias tfplan='tf plan -compact-warnings -detailed-exitcode'
alias tfapply='tf apply -input=false -lock=false -compact-warnings -auto-approve'
alias akamai-tf='AKAMAI_EDGERC_SECTION=papi akamai terraform'

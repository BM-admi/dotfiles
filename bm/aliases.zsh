# $HOME/.oh-my-zsh/custom/aliases.zsh

del_stopped(){
	local name=$1
	local state
	state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

	if [[ "$state" == "false" ]]; then
		docker rm "$name"
	fi
}
alias del_stopped="del_stopped"

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

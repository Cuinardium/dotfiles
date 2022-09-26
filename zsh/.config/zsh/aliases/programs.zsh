# builtin
alias c='clear'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# nvim
alias vim='nvim'
alias nv='nvim'

# Misc
alias spotify='spt'
alias hackerman='cmatrix'
alias lgbt_hackeman='cmatrix | lolcat'
alias pipes='pipes.sh'
alias weather='curl wttr.in/BuenosAires\?0nqf'
alias tuki='echo tuki | cowsay -f bud-frogs | lolcat'
alias mk='ad'
eval $(thefuck --alias)

# docker sistemas operativos
alias so-docker='$HOME/ITBA/SO/scripts/run_docker_itba.sh'
alias so-docker-bash='docker exec -ti $(docker ps | tail -n1 | cut -d " " -f 1) bash'

# ssh
alias mount-server-local='sshfs cuini@192.168.0.31:/home/cuini/shared ~/shared -C -o IdentityFile=/Users/cuini/.ssh/home-server-id'
alias mount-server-remote='sshfs cuini@cuini-server.duckdns.org:/home/cuini/shared ~/shared -C -p 69 -o IdentityFile=/Users/cuini/.ssh/home-server-id'
alias unmount-server='umount -f ~/shared'

alias ssh-server-remote='ssh cuini@cuini-server.duckdns.org -p 69'
alias ssh-server-local='ssh cuini@192.168.0.31'

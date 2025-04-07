# builtin
alias c='clear'

# Better ls
alias ls='lsd'

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias tree='lsd --tree'

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
alias miller='clear && pv -qL 50 /home/cuini/Documents/ley-bases.txt'
# eval $(thefuck --alias)

# docker sistemas operativos
alias so-docker='docker run -v "${PWD}:/root" --platform linux/amd64 --cap-add=SYS_PTRACE --privileged -ti imnotgone/itba-so:latest'
alias so-docker-bash='docker exec -ti $(docker ps | tail -n1 | cut -d " " -f 1) bash'

# ssh
alias mount-server-local='sshfs -o allow_other cuini@192.168.0.31:/home/cuini/shared ~/shared -C -o IdentityFile=/home/cuini/.ssh/home-server-id'
alias mount-server-remote='sshfs -o allow_other cuini@cuini-server.duckdns.org:/home/cuini/shared ~/shared -C -p 69 -o IdentityFile=/home/cuini/.ssh/home-server-id'
alias unmount-server='umount -f ~/shared'

alias ssh-server-remote='ssh cuini@cuini-server.duckdns.org -p 69 -o IdentityFile=/home/cuini/.ssh/home-server-id'
alias ssh-server-local='ssh cuini@192.168.0.31 -o IdentityFile=/home/cuini/.ssh/home-server-id'

alias pgcli-server-peliculas='pgcli postgresql://cuini@localhost:5432/peliculas --ssh-tunnel 192.168.0.31'
alias mongo-server="mongosh --host 192.168.0.31 -u cuini -p secreto --authenticationDatabase lab"

# java
alias j8='sudo archlinux-java set java-8-openjdk'
alias j11='sudo archlinux-java set java-11-openjdk'
alias j17='sudo archlinux-java set java-17-openjdk'
alias j22='sudo archlinux-java set java-22-openjdk'

# Copilot cli
eval "$(github-copilot-cli alias -- "$0")"

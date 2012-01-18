#--------alias--------
#screen
alias sco='sshproxy;screen'
alias scl='screen -ls'
alias scq='quitscr() { screen -X -S $1 quit; };quitscr'
alias scr='screen -raAd'

#apt-get & aptitude
alias s-install='sudo aptitude install'
alias s-purge='sudo aptitude purge'
alias s-search='aptitude search'
alias s-show='aptitude show'
alias s-update='sudo aptitude update'

#代理设置
alias goaproxy='nohup ~/soft/goagent-1.7.9/local/proxy.py > /dev/null &'

#其他
alias ls-hd='df -T -h -x tmpfs -x devtmpfs'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

#快速启动
alias git-c='git commit -a -m'

#--------环境变量--------

#xterm-256色支持
export TERM=xterm-256color

#PATH路径
export PATH=$PATH:$HOME/works/shells


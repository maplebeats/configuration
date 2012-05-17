#alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias p-s='sudo pacman -S'
alias p-ss='pacman -Ss'
alias y-s='sudo yaourt -S'
alias y-ss='yaourt -Ss' 

#proxy
alias goaproxy='`nohup python2 ~/Software/goagent-1.7.9/local/proxy.py&`'

#env
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export PATH=$PATH:~/.gem/ruby/1.9.1/bin
PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]^_^\[\e[0m\]; else echo \[\e[31m\]QAQ\[\e[0m\]; fi\`[\u@\h:\w]\\$ "

#git
alias git-c='git commit -a -m'
alias git-p='git push'
alias git-a='git add .'

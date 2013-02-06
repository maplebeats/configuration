PROMPT='%{[31m%}ef>%{[m%}'

case $TERM in
    (xterm*)
        function precmd () { print -Pn "\e]0;%~\a" }
    ;;
esac

[[ ! -o login ]] && source /etc/zsh/zprofile

export PATH=$PATH:/home/maplebeats/Scripts:/home/maplebeats/.gem/ruby/1.9.1/bin:/usr/share/perl5/core_perl/:/usr/share/perl5/vendor_perl/
export PYTHONPATH=/usr/local/lib/python3.2/site-packages/:/home/maplebeats/pylib
export EDITOR="vim"

# number of lines kept in history
export HISTSIZE=10000
# # number of lines saved in the history after logout
export SAVEHIST=10000
# # location of history
export HISTFILE=~/.zhistory
# # append command to history file once executed
setopt INC_APPEND_HISTORY

#Disable core dumps
limit coredumpsize 0

bindkey "\e[3~" delete-char

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

autoload -U compinit
compinit

# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always

[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

#alias
alias rm='rm -i'
alias ls='ls -F --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias git-c="git commit -a -m"
alias menu="xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > ~/.config/awesome/menu.lua && sed -i -r -e 's/\.svg/\.png/' -e 's/\.ico/\.png/' ~/.config/awesome/menu.lua"
alias sys='sudo systemctl'
alias up='yaourt -Syua'
alias py='python3'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias op='xdg-open'
alias pacman='pacman-color'
alias y='ydcv'
alias s='sdcv'

function dooloo () { 
    curl -s dooloo.info |  awk '
    BEGIN { RS=">\n"; FS="[\"><]|=\x27" } 
    /title=/ {
        sub("/", "http://dooloo.info/", $3); 
        print "[\033[32m"$7"\033[39m]\n\033[36m"$3"\033[39m\n"
    }
'; }
function reload() {
    source ~/.zshrc
}
alias rl='reload'

function cdd(){
    cd $1 && ll $PWD
    print '\033[33mPWD:'"\033[32m"$PWD
}

function j(){
    if [ ! "$#" -eq 1 ]; then
        echo 'Args error'
        return 1
    fi 
    case "$1" in 
        "$HOME")
            cdd ~
            ;;
        "v")
            cdd ~/Videos
            ;;
        "s")
            cdd ~/Software
            ;;
        "w")
            cdd ~/Works
            ;;
        *)
            dir=`autojump "$1"` && cdd $dir || echo 'No such dir';return 1;
            ;;
    esac
}
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

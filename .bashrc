# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
PS1="\342\224\214\342\224\200 \e[32m\u@\h:\e[34m\w\e[m - \t \d \n\342\224\224\342\224\200\342\224\200> $ "

# alias mc='export MC_PROFILE_ROOT=/home/drcyber/.config/mc && mc'
alias mc7='export MC_PROFILE_ROOT=/home/drcyber/.config/mc7 && mc'
alias st='st -f "${ST_FONT:-VictorMono:pixelsize=30:antialias=true:autohint=true}"'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# подключаем grc
alias configure="grc --colour=auto configure"
alias ping="grc --colour=auto ping"
alias traceroute="grc --colour=auto traceroute"
alias gcc="grc --colour=auto gcc"
alias gcc="grc --colour=auto gcc"
alias netstat="grc --colour=auto netstat"
alias stat="grc --colour=auto stat"
alias ss="grc --colour=auto ss"
alias diff="grc --colour=auto diff"
alias wdiff="grc --colour=auto wdiff"
alias last="grc --colour=auto last"
alias ldap="grc --colour=auto ldap"
alias cvs="grc --colour=auto cvs"
alias mount="grc --colour=auto mount"
alias findmnt="grc --colour=auto findmnt"
alias mtr="grc --colour=auto mtr"
alias ps="grc --colour=auto ps"
alias dig="grc --colour=auto dig"
alias ifconfig="grc --colour=auto ifconfig"
# alias ls="grc --colour=auto ls"
alias mount="grc --colour=auto mount"
alias df="grc --colour=auto df"
alias du="grc --colour=auto du"
alias ipaddr="grc --colour=auto ipaddr"
alias ipaddr="grc --colour=auto ipaddr"
alias iproute="grc --colour=auto iproute"
alias ipneighbor="grc --colour=auto ipneighbor"
alias ip="grc --colour=auto ip"
alias env="grc --colour=auto env"
alias env="grc --colour=auto env"
alias iptables="grc --colour=auto iptables"
alias lspci="grc --colour=auto lspci"
alias lsblk="grc --colour=auto lsblk"
alias lsof="grc --colour=auto lsof"
alias blkid="grc --colour=auto blkid"
alias id="grc --colour=auto id"
alias iostat_sar="grc --colour=auto iostat_sar"
alias fdisk="grc --colour=auto fdisk"
alias free="grc --colour=auto free"
alias dockerps="grc --colour=auto dockerps"
alias dockerimages="grc --colour=auto dockerimages"
alias dockersearch="grc --colour=auto dockersearch"
alias dockerpull="grc --colour=auto dockerpull"
alias docker-machinels="grc --colour=auto docker-machinels"
alias dockernetwork="grc --colour=auto dockernetwork"
alias dockerinfo="grc --colour=auto dockerinfo"
alias dockerversion="grc --colour=auto dockerversion"
alias log="grc --colour=auto log"
alias kubectl="grc --colour=auto kubectl"
alias sensors="grc --colour=auto sensors"
alias systemctl="grc --colour=auto systemctl"
alias sysctl="grc --colour=auto sysctl"
alias tcpdump="grc --colour=auto tcpdump"
alias tune2fs="grc --colour=auto tune2fs"
alias lsmod="grc --colour=auto lsmod"
alias lsattr="grc --colour=auto lsattr"
alias semanageboolean="grc --colour=auto semanageboolean"
alias semanagefcontext="grc --colour=auto semanagefcontext"
alias semanageuser="grc --colour=auto semanageuser"
alias getsebool="grc --colour=auto getsebool"
alias ulimit="grc --colour=auto ulimit"
alias vmstat="grc --colour=auto vmstat"
alias dnf="grc --colour=auto dnf"
alias nmap="grc --colour=auto nmap"
alias uptime="grc --colour=auto uptime"
alias getfacl="grc --colour=auto getfacl"
alias ntpdate="grc --colour=auto ntpdate"
alias showmount="grc --colour=auto showmount"
alias ant="grc --colour=auto ant"
alias mvn="grc --colour=auto mvn"
alias iwconfig="grc --colour=auto iwconfig"
alias lolcat="grc --colour=auto lolcat"
alias whois="grc --colour=auto whois"
alias go-test="grc --colour=auto go-test"
alias sockstat="grc --colour=auto sockstat"
alias irclog="grc --colour=auto irclog"
alias log="grc --colour=auto log"

#################
# Bash settings #
#################

# Don't do anything, if not interactive
case $- in
  *i*) ;;
    *) return;;
esac

# Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Always check terminal dimensions
shopt -s checkwinsize

# History settings
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000


##########
# Prompt #
##########

pwd_abbr () {
  echo "$(\
    p="${PWD#${HOME}}"; \
    [[ "${PWD}" != "${p}" ]] && printf "~"; \
    
    IFS=/; \
    for q in ${p:1}; do \
      [[ "${q:0:1}" == "." ]] && printf "/${q:0:2}" || printf "/${q:0:1}"; \
    done; \
    printf "${q:1}" \
  )"
}

exit_color () {
  local ecode="$?"
  local fmtcode="$(printf "%03d" "$ecode")"

  if [[ "$ecode" == "0" ]]; then
    echo -ne "\e[32m \u2713 \e[0m"
  else
    echo -ne "\e[31m$fmtcode\e[0m"
  fi
}

#    reset exit code          host/user   +      pwd              $
PS1='\e[0m[$(exit_color)] \e[32m\h\e[0m/\e[96m\u\e[0m:\e[95m$(pwd_abbr)\e[00m$ '


###########
# Aliases #
###########

# colorization
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -lahF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# in case someone fucked up again... (me)
alias fuck='sudo $(fc -ln -1)'

# list all currently listening tcp sockets
alias lssockets='ss -nrlpt'

# pretty mount table
alias mountfmt="mount | column -t | sort"

# upload to https://0x0.st
0x0 () {
  echo ">>  $(curl -s --fail -F "file=@$1" "https://0x0.st" || echo "error uploading $1")"
}

# config management with git
dotconf () {
  local cdir="$HOME/.dotconf"

  [[ -d $cdir ]] || mkdir -p $cdir
  [[ -f $cdir/HEAD ]] || git init --bare $cdir

  git --git-dir=$cdir --work-tree=$HOME/ "$@"
}


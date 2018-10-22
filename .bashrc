#################
# Bash settings #
#################

# stop if non-interactive
case $- in
  *i*) ;;
    *) return;;
esac

# load bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# check terminal dimensions after each command
shopt -s autocd
shopt -s checkwinsize

# history settings
shopt -s histappend
shopt -s hist_ignore_dups
HISTCONTROL=ignoreboth
HISTSIZE=10000
SAVEHIST=10000


##########
# Prompt #
##########

PROMPT_COMMAND=__render_prompt

__render_prompt () {
  local ecode="$?"
  local fmtcode="$(printf "%03d" "$ecode")"

  # reset
  PS1='\[\e[0m\]'
  
  # exit code
  PS1+='['
  if [[ "$ecode" == "0" ]]; then
    PS1+='\[\033[32m\]'
    PS1+=$' \xe2\x9c\x93 '
  else
    PS1+='\[\033[31m\]'
    PS1+="$fmtcode"
  fi
  PS1+='\[\033[0m\]] '

  # hostname/user:
  PS1+='\[\e[32m\]\h\[\e[0m\]'
  PS1+='/'
  PS1+='\[\e[96m\]\u\[\e[0m\]'
  PS1+=':'

  # pwd (abbreviated)
  PS1+="\[\e[95m\]"
  PS1+="$(
    p="${PWD#${HOME}}"
    [[ "${PWD}" != "${p}" ]] && printf "~"

    IFS=/

    for d in ${p:1}; do
      [[ "${d:0:1}" == "." ]] && printf "/${d:0:2}" || printf "/${d:0:1}"
    done

    [[ "${d:0:1}" == "." ]] && printf "${d:2}" || printf "${d:1}"
  )"
  PS1+='\[\e[00m\]'

  # prompt
  if [ "$UID" -eq "0" ]; then
    PS1+='# '
  else
    PS1+='$ '
  fi
}


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


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

# shopt
shopt -s autocd
shopt -s checkwinsize
shopt -s histappend
shopt -s dotglob
shopt -s globstar

# history settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
SAVEHIST=10000


#################
# PATH variable #
#################

PRIVATE_BIN_PATH="${HOME}/.bin"

if [[ -d $PRIVATE_BIN_PATH ]] && [[ ":$PATH:" != *":$PRIVATE_BIN_PATH:"* ]]; then
  export PATH="${PRIVATE_BIN_PATH}:${PATH}"
fi


#################
# Custom prompt #
#################

PROMPT_COMMAND=__render_prompt

__render_prompt () {
  local ecode="$?"
  local fmtcode="$(printf "%03d" "$ecode")"

  # reset
  PS1='\[\e[0m\]'
  
  # exit code
  PS1+='['
  if [[ $ecode == "0" ]]; then
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
    if [[ $PWD = / ]]; then
      printf '/'
    else
      p="${PWD#${HOME}}"
      
      [[ $PWD != $p ]] && printf "~"
  
      IFS=/
      for d in ${p:1}; do
        [[ ${d:0:1} == "." ]] && printf "/${d:0:2}" || printf "/${d:0:1}"
      done
  
      [[ ${d:0:1} == "." ]] && printf "${d:2}" || printf "${d:1}"
    fi
  )"
  PS1+='\[\e[00m\]'

  # privilege
  if [[ $UID == "0" ]]; then
    PS1+='# '
  else
    PS1+='$ '
  fi
}


###########
# Aliases #
###########

# vim all the things
if [[ -x "$(command -v vim)" ]]; then
  alias vi='vim'
  export EDITOR="vim"
  export VISUAL="vim"
fi

# ls shortcuts
if [[ -x "$(command -v exa)" ]]; then
  alias ls="exa --header --extended --git --group --group-directories-first --color-scale --color=always"
  alias lm="exa --header --long --group --sort=modified --reverse --color always --color-scale"
  alias lt="exa --long --tree --git-ignore"
else
  alias ls='ls -h --color=auto'
fi

alias ll='ls -l'
alias la='ls -la'

# in case someone fucked up again... (me)
alias fuck='sudo env "PATH=$PATH" $(fc -ln -1)'

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


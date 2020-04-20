#################### for neovim
export XDG_CONFIG_HOME=$HOME/.config


#################### complition
fpath=(/usr/local/share/zsh-completions $fpath)

autoload -Uz compinit
compinit -u
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'


#################### vi keybind on command line
bindkey -e


#################### LANG
export LANG=ja_JP.UTF-8
case ${UID} in
  0)
    LANG=C
    ;;
esac


#################### setopt
setopt auto_cd
setopt auto_pushd
setopt complete_aliases
setopt correct
setopt extended_glob
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt list_packed
setopt noautoremoveslash
setopt nolistbeep
setopt no_beep
setopt share_history
setopt pushd_ignore_dups
setopt print_eight_bit
setopt ignore_eof


#################### prompt
autoload colors
colors

########## git status
setopt prompt_subst
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function rprompt-git-current-branch {
  local name st color gitdir action
  if [[ "$PWD" =~ '/¥.git(/.*)?$' ]]; then
    return
  fi
  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  if [[ -z $name ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%B%F{red}
  else
     color=%F{red}
  fi
  echo "$color$name$action%f%b "
}
GIT_STATUS='`rprompt-git-current-branch`'
#RPROMPT='`rprompt-git-current-branch`'
########## git status

setopt prompt_subst
local p_rshst=""
if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
  local rhost=`who ami i | sed 's/.*(\(.*\)).*/\1/'`
  rhost=${rhost#localhost:}
  rhost=${rhost%%.*}
  p_rhst="%B%F{yellow}($rhost)%f%b"
fi

local p_cdir="%B%F{red}%n%F{yellow}@%m%F{cyan}[%~] ${GIT_STATUS}%f%b"$'\n'
local p_info="%B%F{green}${WINDOW:+"[$WINDOW]"}%f%b"
local p_mark="%B%(?,%F{green},%F{red})%(!,#,$)%f%b"
PROMPT="$p_cdir$p_rhst$p_info$p_mark "
PROMPT2="(%_) %(!,#,$) "
SPROMPT="'%r' correct? [n,y,a,e]: "


#################### history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
#setopt share_history


#################### set history search keys
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


#################### predict
##autoload predict-on
##predict-on


#################### direnv
eval "$(/usr/local/bin/direnv hook zsh)"


#################### gcloud

#################### rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - zsh)"


#################### gopath
export GOPATH=$HOME/.go
export PATH=$HOME/.go/bin:$PATH

#################### python
# export PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
# export PYENV_ROOT="$HOME/.pyenv"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#################### nodejs
# disable this env at 2018/9/4 for wantedly, they use nodenv instead of this
# export PATH=$HOME/.nodebrew/current/bin:$PATH
#
# enable nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"


#################### tmux
if [ -f ~/dotfiles/tmuxinator.zsh ]; then
  source ~/dotfiles/tmuxinator.zsh
fi


#################### cool-peco init
FPATH="${FPATH}:${HOME}/.ghq/github.com/ryoppy/cool-peco"
autoload -Uz cool-peco
cool-peco

bindkey '^r' cool-peco-history # ctrl+r

alias ff=cool-peco-filename-search
alias gbb=cool-peco-git-checkout
alias gll=cool-peco-git-log
alias ta=cool-peco-tmux-session
alias cg=cool-peco-ghq
alias pps=cool-peco-ps


#################### docker
# if which docker-machine > /dev/null; then eval "$(docker-machine env default)"; fi


#################### original commands
export PATH=$HOME/dotfiles/bin:$PATH
export PATH=$HOME/bin:$PATH


#################### source the private setting files
[ -f ~/dotfiles/zshrc.mine ] && source ~/dotfiles/zshrc.mine

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shoheiihaya/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/shoheiihaya/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shoheiihaya/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/shoheiihaya/google-cloud-sdk/completion.zsh.inc'; fi

#################### ls custom
alias ls='ls -G'
export LSCOLORS=cxfxcxdxbxegedabagacad

### Escape overlap $PATH when tmux is loaded
typeset -U path PATH

##################### alias

alias tmux='tmux -2'
alias vi='nvim'
alias vim='nvim'
alias be='bundle exec'
alias gs='git status'
alias gdh='git diff HEAD'
alias gbdm='git branch -d `git branch --merged | grep -v \* | grep -v master`'
alias gcmt='git commit -m'
alias gpu='git push -u origin `git rev-parse --abbrev-ref HEAD`'
alias gh="open \`git remote get-url origin | sed -Ee 's#(ssh://)?(git@|git://)#http://#' -e 's@com:@com/@'\`"
alias od='OVERCOMMIT_DISABLE=1'
alias top='top -ocpu'
alias ssh='if ! ssh-add -l >& /dev/null ; then ssh-add -t 12h ; fi ; ssh'

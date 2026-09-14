source /opt/homebrew/Cellar/zplug/2.4.2/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search", as:plugin
zplug "zsh-users/zsh-autosuggestions"

# zplug "plugins/git", from:oh-my-zsh
zplug bobsoppe/zsh-ssh-agent, use:ssh-agent.zsh, from:github

##########
# PROMPT #
##########

setopt PROMPT_SUBST
autoload -U colors && colors

local current_time="%{$fg[white]%}[%D{%I:%M:%S %p}] "
local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{247}--%{$reset_color%} %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

PROMPT="
${current_time} \
%{$fg_bold[yellow]%}${current_dir}%{$reset_color%} \
${git_info}
%F{9}▶ %{$reset_color%}"

########
# Keys #
########

bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
bindkey "^[[3~" delete-char

if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

###########
# Aliases #
###########

alias gpusho='git push origin $(git_current_branch)'
alias gpullo='git pull origin $(git_current_branch)'
alias gcam='git commit -am'
alias gcob='git checkout -b'
# show git diff stats on current branch to master
alias gstatbranch='git diff --stat master..$(git_current_branch)'
alias gstatbranch_main='git diff --stat main..$(git_current_branch)'

alias gotocode='cd ~/Wealthsimple/Dev'

alias startdb='pg_ctl -D /opt/homebrew/var/postgres start'

#############
# Functions #
#############

# git rebase the given number of commits
grebi () { git rebase -i HEAD~$@ }

# git log with tree given number of commits
glogtree () { git log --all --decorate --graph --oneline -$@ }

# git diff stat the head and N commits back in time
gstat () { git diff --stat HEAD~$@ HEAD }

# git fetch a branch from origin and checkout to it
gcobfetch () { git fetch origin $@:$@ ; git checkout $@ }

# git commit staged and rebase it with parent
gcmrebi2 () { git commit -m "WIP" ; grebi 2 }

# git checkout master, pull, go back to feature branch, merge master in
gcomergemaster () { git checkout master ; gpullo ; git checkout - ; git merge master }
gcomergemain () { git checkout main ; gpullo ; git checkout - ; git merge main }

# git checkout master, pull, go back to feature branch and rebase onto master
gcorebmaster () { git checkout master ; gpullo ; git checkout - ; git rebase master }
gcorebmain () { git checkout main ; gpullo ; git checkout - ; git rebase main }


###########
# Exports #
###########

export TERM=xterm-256color

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export REDIS_CLUSTER_IP=0.0.0.0

# Credentials to run hypercube locally: expired Aug 5 2026
export SATORI_USERNAME="aseegobin"
export SATORI_PASSWORD="{REDACTED}"

# Note: You can get this value by running "make devschema"
export DEV_SQL_SCHEMA_PREFIX="aseegobin"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

eval "$(direnv hook zsh)"

# Then, source plugins and add commands to $PATH
zplug load
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH="$PATH:$HOME/bin" # Add personal ~/bin to PATH for scripting
export PATH="$HOME/.local/bin:$PATH"
export ROLLBAR_KEY={READCTED}
source /Users/aseegobin/.config/wealthsimple/direnv/config.zsh

# Pyenv tool to switch between python versions
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# Activate mise to control code environments
eval "$(mise activate zsh)"

# Pull in dev secrets for various projects
source ~/.config/wealthsimple/env.secrets

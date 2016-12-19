source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search", as:plugin
zplug "zsh-users/zsh-completions", as:plugin, use:"src"
zplug "zsh-users/zsh-autosuggestions", as:plugin, use:"src"

zplug "plugins/git", from:oh-my-zsh


##########
# PROMPT #
##########

setopt PROMPT_SUBST
autoload -U colors && colors

local current_time="%{$fg[white]%}[%*] "
local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} git:%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

PROMPT="
${current_time} \
%{$fg_bold[yellow]%}${current_dir}%{$reset_color%} \
${git_info}
%{$fg_bold[magenta]%}▶ %{$reset_color%}"



########
# Keys #
########

bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
bindkey "^[[3~" delete-char

###########
# Aliases #
###########

alias gpusho='git push origin $(git_current_branch)'
alias gcam='git commit -am'


###########
# Exports #
###########

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export TERM=xterm-256color


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

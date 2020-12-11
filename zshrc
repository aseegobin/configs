source /usr/local/opt/zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search", as:plugin
zplug "zsh-users/zsh-autosuggestions"

zplug "plugins/git", from:oh-my-zsh
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

alias fsbdeploy='./gradlew deploy -x test -x findbugsMain -x findbugsInteg -x findbugsTest -x checkStyleMain -x checkStyleInteg -x checkStyleTest'

alias deliverydeploy='./gradlew delivery:deploy -x test -x findbugsMain -x findbugsInteg -x findbugsTest -x checkStyleMain -x checkStyleInteg -x checkStyleTest'

alias sourceaws='source ~/.aws-perms ; echo SOURCED'

alias sourceaws_thebitstrips='source ~/.aws-perms-thebitstrips ; echo SOURCED THEBISTRIPS'

alias sourceaws_skeletor='source ~/.aws-perms-skeletor ; echo SOURCED SKELETOR'

alias sourceaws_havarti='source ~/.aws-perms-havarti ; echo SOURCED HAVARTI'

alias sourceaws_havarti_staging='source ~/.aws-perms-havarti-staging ; echo SOURCED HAVARTI STAGING'

alias sourceaws_rendering='source ~/.aws-perms-rendering ; echo SOURCED RENDERING'

alias sourceaws_rendering_staging='source ~/.aws-perms-rendering-staging ; echo SOURCED RENDERING STAGING'

alias sourceaws_rendering_staging_ADMIN='source ~/.aws-perms-rendering-staging-admin ; echo SOURCED RENDERING STAGING ADMIN'

alias sourceaws_cerebellum='source ~/.aws-perms-cerebellum ; echo SOURCED CEREBELLLMY'

alias exportjava7='export JAVA_HOME=`/usr/libexec/java_home -v 1.7` ; echo EXPORTED'

alias exportjava11='export JAVA_HOME=`/usr/libexec/java_home -v 11` ; echo EXPORTED'

alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; echo LOADED'

alias snapvpn='snapaccess credentials refresh'

alias gotocode='cd ~/Snapchat/Dev'

alias installandroid='./gradlew imoji-app:installDebug'

alias gcloudauth='gcloud components update ; gcloud auth application-default login --scopes="https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/cloud-platform"'

#############
# Functions #
#############

setTerminalText () {
  # echo works in bash & zsh
  DISABLE_AUTO_TITLE="true"
  local mode=$1 ; shift
  echo -ne "\033]$mode;$@\007"
}
stt_both  () { setTerminalText 0 $@; }
stt_tab   () { setTerminalText 1 $@; }
stt_title () { setTerminalText 2 $@; }

setTerminalTabColor () {
  echo -n -e "\033]6;1;bg;red;brightness;$1\a"
  echo -n -e "\033]6;1;bg;green;brightness;$2\a"
  echo -n -e "\033]6;1;bg;blue;brightness;$3\a"
}
sttc_red () { setTerminalTabColor 195 89 76; }
sttc_green () { setTerminalTabColor 65 174 76; }
sttc_blue () { setTerminalTabColor 92 155 204; }
sttc_yellow () { setTerminalTabColor 240 240 0; }
sttc_purple () { setTerminalTabColor 216 55 230; }
sttc_teal () { setTerminalTabColor 55 200 230; }
sttc_brown () { setTerminalTabColor 255 160 20; }

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

# gifify for each type of screen recording
# - pass in the video file and it outputs a .gif of the same name in the current folder
gif-vid-desktop () { gifify $1 --colors 255 --fps 30 --resize -1:500 -o ${1%%.*}.gif }
gif-vid-desktop-small () { gifify $1 --colors 255 --fps 20 --resize -1:500 -o ${1%%.*}.gif }
gif-vid-desktop-fast () { gifify $1 --colors 255 --fps 10 --resize -1:500 -o ${1%%.*}.gif --speed 2 }
gif-vid-phone () { gifify $1 --colors 255 --fps 30 --resize 400:-1 -o ${1%%.*}.gif }
gif-vid-phone-small () { gifify $1 --colors 255 --fps 20 --resize 400:-1 -o ${1%%.*}.gif }
gif-vid-phone-fast () { gifify $1 --colors 255 --fps 10 --resize 400:-1 -o ${1%%.*}.gif --speed 2}

# gradle deployment without any tests, lint, etc.
gradlewdeploy () { ./gradlew $1:deploy -x test -x findbugsMain -x findbugsInteg -x findbugsTest -x checkStyleMain -x checkStyleInteg -x checkStyleTest }

###########
# Exports #
###########

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$JAVA_HOME/bin"
export TERM=xterm-256color
export NVM_DIR="$HOME/.nvm"
export HUNTER_ROOT=/Users/avie.seegobin/Snapchat/Dev/hunter

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH="$PATH:$HOME/bin" # Add personal ~/bin to PATH for scripting

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/avie.seegobin/Downloads/google-cloud-sdk 5.17.01 PM/path.zsh.inc' ]; then source '/Users/avie.seegobin/Downloads/google-cloud-sdk 5.17.01 PM/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/avie.seegobin/Downloads/google-cloud-sdk 5.17.01 PM/completion.zsh.inc' ]; then source '/Users/avie.seegobin/Downloads/google-cloud-sdk 5.17.01 PM/completion.zsh.inc'; fi

# Specific for work
snapvpn

# ~/.config/fish/config.fish

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showcleanstate 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_cleanstate '✅ '
set __fish_git_prompt_char_dirtystate '⚡ '
set __fish_git_prompt_char_stagedstate '⚒ '
set __fish_git_prompt_char_untrackedfiles '⚠️ '



function fish_prompt --description 'Write out the prompt'
  # Just calculate this once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  set -l color_cwd
  set -l suffix
  set last_status $status
  switch $USER
  case root toor
    if set -q fish_color_cwd_root
      set color_cwd $fish_color_cwd_root
    else
      set color_cwd $fish_color_cwd
    end
    set suffix '#'
  case '*'
    set color_cwd $fish_color_cwd
    set suffix '>'
  end

  set -g hours (date +%H)
  set -l mins (date +%M)
  set -l secs (date +%S)
  set -g ampm 'AM'

  if [ $hours -ge "12" ]
    set ampm 'PM'
  end

  if [ $hours -gt "12" ]
    set hours (math $hours - 12)
  end


  set -l time "$hours:$mins:$secs $ampm"

  echo -n -s "["(set_color magenta) "$time" (set_color normal)"] - $USER" @ "$__fish_prompt_hostname" ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt) " $suffix "
end

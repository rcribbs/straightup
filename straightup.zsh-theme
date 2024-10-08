#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
#
# Straighup - A minimalistic theme that matches my tastes.
#
# Based on a little of the sugar-free theme and a little of a theme by taktoa.
#
# Taktoa <https://github.com/oh-my-fish/theme-taktoa>
# Sugar-Free <https://github.com/cbrock/sugar-free>
#
# ------------------------------------------------------------------------------

GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
GIT_PROMPT_SUFFIX="%{$reset_color%} "

# These colors match my .gitconfig:
# [color "status"]
#     added = yellow
#     changed = green
#     untracked = cyan
GIT_PROMPT_MODIFIED="%{$fg_bold[red]%}*%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}+%{$reset_color%}"

_git_status_symbol() {
    git_status = $(git status --porcelain ^/dev/null)
}

_git_most_common_extension() {
    echo git ls-files | sed -n 's/..*\.//p' | uniq -c | sort -r | HEAD -1 |\
        awk '{ print $2 }'
}

# Show Git branch/tag, or name-rev if on detached head
_parse_git_branch() {
  (gtimeout .25 git symbolic-ref -q HEAD || \
      gtimeout .25 git name-rev --name-only --no-undefined --always HEAD) 2> \
      /dev/null
}

# Show different symbols as appropriate for various Git repository states
_parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_STATE"
  fi

}

# If inside a Git repository, print its branch and state
_sup_git_prompt_string() {
  local git_where="$(_parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%{$fg[cyan]%}\
${git_where#(refs/heads/|tags/)}$(_parse_git_state)$GIT_PROMPT_SUFFIX"
}

_sup_virtual_env_string() {
    [ -n "$VIRTUAL_ENV" ] && local virtual_env="$(basename $VIRTUAL_ENV)"
    [ -n "$virtual_env" ] && echo "<<$virtual_env>> "
}

_get_path() {
    shrink_path -f
}

function _remote_hostname() {
    echo $(whoami)
    if [ -n "$SSH_CONNECTION" ]; then
        echo " (ssh)"
    fi
}


_sup_blue_fg() {
    echo -n "%{$fg[blue]%}"
}

_sup_green_fg() {
    echo -n "%{$fg[green]%}"
}

_sup_yellow_fg() {
    echo -n "%{$fg[yellow]%}"
}

_sup_magenta_fg() {
    echo -n "%{$fg[magenta]%}"
}

_sup_white_fg() {
    echo -n "%{$fg[white]%}"
}

_sup_reset_color() {
    echo -n "%{$reset_color%}"
}

PROMPT='$(_sup_blue_fg)$(_remote_hostname)$(_sup_reset_color) '
PROMPT+='$(_sup_yellow_fg)$(_get_path)$(_sup_reset_color) '
PROMPT+='$(_sup_white_fg)$(_sup_git_prompt_string)'
PROMPT+='$(_sup_magenta_fg)$(_sup_virtual_env_string)'
PROMPT+='$(_sup_blue_fg)❯ '

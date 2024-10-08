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

GIT_PROMPT_PREFIX="%F{white}(%F{reset}"
GIT_PROMPT_SUFFIX="%F{white}%F{reset})"

GIT_PROMPT_MODIFIED="%B%F{red}*%b%F{reset}"
GIT_PROMPT_STAGED="%B%F{green}+%b%F{reset}"

_git_most_common_extension() {
    echo git ls-files | sed -n 's/..*\.//p' | uniq -c | sort -r | HEAD -1 |\
        awk '{ print $2 }'
}

_parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
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
_git_prompt_string() {
  local git_where="$(_parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%F{white}${git_where#(refs/heads/|tags/)}$(_parse_git_state)$GIT_PROMPT_SUFFIX"
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

PROMPT=$'%F{blue}%n %F{reset}%F{green}$(_get_path)%F{reset} $(_git_prompt_string)%F{blue}%F{blue}❯%F{reset} '

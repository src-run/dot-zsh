#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# Include phpenv shell helpers.
#

_incLog 2 2 "Initializing phpenv"

_PHPENV_ROOT="${HOME}/.phpenv"
_PHPENV_BIN="${_PHPENV_ROOT}/bin"
_PHPENV_COMPLETIONS="${_PHPENV_ROOT}/completions/rbenv.zsh"

if [[ ! -d "${_PHPENV_ROOT}" ]]; then
    _dzsh_warning "Root phpenv path not found: ${_PHPENV_ROOT}"
else
  if [[ ! -d "${_PHPENV_BIN}" ]]; then
    _dzsh_warning "Bin directory for phpenv not found: ${_PHPENV_BIN}"
  else
    _dotZshPathVariableAddition "${_PHPENV_BIN}"
  fi


  if [[ ! -f "${_PHPENV_COMPLETIONS}" ]]; then
      _dzsh_warning "Completions for phpenv not found: ${_PHPENV_COMPLETIONS}"
  else
    source "${_PHPENV_COMPLETIONS}" 2>/dev/null && _incLog 2 2 "Sourcing file ${_PHPENV_COMPLETIONS}"
  fi

  eval "$(phpenv init -)" && _actLog "Initializing phpenv"
fi

# EOF

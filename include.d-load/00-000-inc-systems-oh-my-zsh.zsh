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
# setup configuration
#

_log_action "Configuring environment variables"
_log_action "Loading configured plugins"


#
# Configure theme to use (See ".oh-my-zsh/themes/" for available themes or use
# the name "random" to have a random theme each time the shell is loaded).
#

ZSH_THEME="$(_log_assignment ZSH_THEME "$(
    _cfg_get_string 'systems.oh_my_zsh.display.prompt_theme'
)")"


#
# Configure colors for "ls" command.
#

DISABLE_LS_COLORS="$(_log_assignment DISABLE_LS_COLORS "$(
    _bool_reverse $(
        _cfg_get_bool 'systems.oh_my_zsh.display.use_ls_color'
    )
)")"


#
# Configure auto-setting of the terminal title.
#

DISABLE_AUTO_TITLE="$(_log_assignment DISABLE_AUTO_TITLE "$(
    _bool_reverse $(
        _cfg_get_bool 'systems.oh_my_zsh.display.window_title_assign'
    )
)")"


#
# Configure the command execution time stamp shown in the history command.
# Formats include: "mm/dd/yyyy" or "dd.mm.yyyy" or "yyyy-mm-dd".
#

HIST_STAMPS="$(_log_assignment HIST_STAMPS "$(
    _cfg_get_string 'systems.oh_my_zsh.display.history_date_format'
)")"


#
# Use case-sensitive completion.
#

CASE_SENSITIVE="$(_log_assignment CASE_SENSITIVE "$(
    _cfg_get_bool 'systems.oh_my_zsh.completions.use_case_sensitivity'
)")"


#
# Use hyphen-insensitive completion. Case-sensitive completion must be off
# and _ and - will be interchangeable.
#

HYPHEN_INSENSITIVE="$(_log_assignment HYPHEN_INSENSITIVE "$(
    _bool_reverse $(
        _cfg_get_bool 'systems.oh_my_zsh.completions.use_hyph_sensitivity'
    )
)")"


#
# Configure command auto-correction.
#

ENABLE_CORRECTION="$(_log_assignment ENABLE_CORRECTION "$(
    _cfg_get_bool 'systems.oh_my_zsh.completions.cmd_show_corrections'
)")"


#
# Configure display of red dots while waiting for completion.
#

COMPLETION_WAITING_DOTS="$(_log_assignment COMPLETION_WAITING_DOTS "$(
    _cfg_get_bool 'systems.oh_my_zsh.completions.display_working_dots'
)")"


#
# Ignore permissions issues when completion files are loaded
#

ZSH_DISABLE_COMPFIX="$(_log_assignment ZSH_DISABLE_COMPFIX "$(
    _cfg_get_bool 'systems.oh_my_zsh.completions.no_permisions_checks'
)")"


#
# Configure bi-weekly auto-update checks.
#

DISABLE_AUTO_UPDATE="$(_log_assignment DISABLE_AUTO_UPDATE "$(
    _bool_reverse $(
        _cfg_get_bool 'systems.oh_my_zsh.updates.auto_check'
    )
)")"


#
# Set how often to auto-update (in days).
#

export UPDATE_ZSH_DAYS="$(_log_assignment UPDATE_ZSH_DAYS "$(
    _cfg_get_number 'systems.oh_my_zsh.updates.every_days'
)")"


#
# Configure whether having untracked files under VCS causes repository to be
# marked as dirty or not. (Disabling makes checks on large repositories
# significantly faster).
#

DISABLE_UNTRACKED_FILES_DIRTY="$(_log_assignment DISABLE_UNTRACKED_FILES_DIRTY "$(
    _bool_reverse $(
        _cfg_get_bool 'systems.oh_my_zsh.git.use_untracked_in_dirty_check'
    )
)")"


#
# define default language
#

export LANG="$(_log_assignment LANG "$(
    _cfg_get_string 'systems.oh_my_zsh.language' 'en_US.UTF-8'
)")"

ZSH_LANG_TYPE="$(_log_assignment ZSH_LANG_TYPE "$(
    _cfg_get_string 'systems.oh_my_zsh.language' 'en_US.UTF-8'
)")"


#
# flush buffered assignment log lines
#

_file_out_buffer


#
# setup plugins
#

plugins=()

for p in $(_cfg_get_array_values 'systems.oh_my_zsh.plugins'); do
    plugins+=(${p}) \
        && _log_action "Setting plugin '${p}' as active" 3
done


#
# attempt to resolve oh-my-zsh real paths
#

if [[ $(which realpath 2> /dev/null) ]]; then
    _OH_ROOT_PATH="$(realpath "${_OH_ROOT_PATH}" 2> /dev/null)"
    _OH_LOAD_PATH="$(realpath "${_OH_LOAD_PATH}" 2> /dev/null)"
fi


#
# export and source oh-my-zsh or display error message
#

if [[ -d "${_OH_ROOT_PATH}" ]] && [[ -f "${_OH_LOAD_PATH}" ]]; then
    export ZSH="${_OH_ROOT_PATH}"
    source "${_OH_LOAD_PATH}" \
        && _log_action "Sourced '${_OH_LOAD_PATH}'..." \
        || _log_warn "Failure sourcing '${_OH_LOAD_PATH}'..."
else
   _log_warn "Failure sourcing '${_OH_LOAD_PATH}'..."
fi

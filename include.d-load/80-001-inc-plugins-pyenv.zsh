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
# Set pyenv variable exports
#

for raw in $(_cfg_get_array_assoc 'plugins.pyenv.env_exports_list'); do
    key="$(_get_array_key "${raw}")"
    val="$(_get_array_val "${raw}")"

    if [[ ${val} == null ]]; then
        export "${key}" &&
            _log_action "Exporting '${key}' variable" ||
            _log_warn "Failed to export '${key}' variable"
    else
        export "${key}"="${val}" &&
            _log_action "Exporting '${key}' variable with '${val}' assignment" ||
            _log_warn "Failed to export '${e}' variable with '${val}' assignment"
    fi
done


#
# Add pyenv executable directories to PATH
#

for f in $(_cfg_get_array_values 'plugins.pyenv.executable_paths'); do
    _add_env_path_dir "${f}" scripted
done


#
# Initialize pyenv
#

_ifs_newlines
for raw in $(_cfg_get_array_assoc 'plugins.pyenv.initialize_evals'); do
    key="$(_get_array_key "${raw}")"
    val="$(_get_array_val "${raw}")"

    if [[ -z ${val} ]]; then
        _log_warn "Failed evaluation of initialization script '${key}': '${val}' (${raw})"
        continue
    fi

    _log_action "Evaluating initialization script '${key}': '${val}'"
    eval "$(eval "${val}")"

    [[ $? -ne 0 ]] && \
        _log_warn "Failed evaluation of initialization script '${key}': '${val}'"
done
_ifs_reset


#
# Add pyenv completion files to environment
#

for f in $(_cfg_get_array_values 'plugins.pyenv.completion_files'); do
    _check_extern_source_file "${f}" 2 'pyenv' && source "${f}"
done

pyenv global "$(_cfg_get_string 'plugins.pyenv.exec_global_vers' 'system')" &> /dev/null && \
    _log_action "Setting global python version: '$(_cfg_get_string 'plugins.pyenv.exec_global_vers' 'system')'" || \
    _log_warn   "Failed setting global python version: '$(_cfg_get_string 'plugins.pyenv.exec_global_vers' 'system')'"

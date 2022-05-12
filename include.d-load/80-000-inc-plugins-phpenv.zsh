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
# Add phpenv executable directories to PATH
#

for f in $(_cfg_get_array_values 'plugins.phpenv.executable_paths'); do
    _add_env_path_dir "${f}" scripted
done


#
# Add phpenv completion files to environment
#

for f in $(_cfg_get_array_values 'plugins.phpenv.completion_files'); do
    _check_extern_source_file "${f}" 2 'phpenv' && source "${f}"
done


#
# Initialize phpenv
#

_ifs_newlines
for eval in $(_cfg_get_array_values 'plugins.phpenv.initialize_evals'); do
    _log_action "Evaluating initialization script: '${eval}'"
    eval "$(eval "${eval}")"

    [[ $? -ne 0 ]] && \
        _log_warn "Failed evaluation of initialization script: '${eval}'"
done
_ifs_reset

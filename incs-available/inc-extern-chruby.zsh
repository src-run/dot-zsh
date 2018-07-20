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
# Source chruby environment and auto-selector scripts
#

for f in $(_config_read_array_vals 'extern["chruby"].env_source_files'); do
    _check_extern_source_file "${f}" 2 'chruby' && source "${f}"
done


#
# Set ruby default interpreter
#
v=$(_config_read_integer 'extern["chruby"].auto_set_version' 'false')

if [[ "${v}" != 'false' ]]; then
    chruby ${v} &> /dev/null && \
        _log_action "Assigned default ruby version to '${v}'" || \
        _log_warn "Failed to set default ruby version to '${v}'"
fi

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

for f in $(_cfg_get_array_values 'plugins.phpenv.executable_paths'); do
    _add_env_path_dir "${f}" scripted
done

for f in $(_cfg_get_array_values 'plugins.phpenv.completion_files'); do
    _check_extern_source_file "${f}" 2 'phpenv' && source "${f}"
done

_ifs_newlines
for e in $(_cfg_get_array_values 'plugins.phpenv.initialize_evals'); do
    eval "$(eval ${e})" && \
        _log_action "Evaluated initialization command '${e}'" || \
        _log_warn "Failed evaluated initialization command '${e}'"
done
_ifs_reset

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
# Loop though exports array and export 'em.
#

for dir in $(_try_read_conf_array_values "internal.change_dir_paths" "${_DZ_CHANGE_DIR_PATHS[@]}"); do
    if [[ ! -d "${dir}" ]]; then
        continue
    fi

    cdpath+=( "${dir}" ) && \
        _log_action "Added '${dir}' to \$cdpath environment" ||
        _log_warn "Failed to add '${dir}' to \$cdpath environment"
done

# EOF

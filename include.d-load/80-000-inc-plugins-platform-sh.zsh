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
# Add platform.sh binaries to PATH
#

for f in $(_cfg_get_array_values 'plugins.platform_sh.executable_paths'); do
    _add_env_path_dir "${f}" scripted
done


#
# Source platform.sh shell config
#

for f in $(_cfg_get_array_values 'plugins.platform_sh.env_source_files'); do
    _check_extern_source_file "${f}" 2 'platform.sh' && source "${f}"
done

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
# Add global composer binaries to PATH
#

for p in $(_cfg_get_array_values 'plugins.composer.executable_paths'); do
    _add_env_path_dir "${p}" scripted
done

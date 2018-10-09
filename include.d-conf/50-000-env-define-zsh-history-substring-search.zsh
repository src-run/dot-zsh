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
# Remove all duplicate entries from history result set.
#

#setopt HIST_IGNORE_ALL_DUPS


#
# Bind "up" and "down" arrow keys to history-substring-search plug-in.
#

#zmodload zsh/terminfo

#for n in ${_DZ_PLUG_HIST_SUB_SRCH_KEY_COMMANDS}; do
#    printf "NAME[%s] TERM[%s]\n" "configs.key_bindings.${n}" "$(
#        _cfg_get_string "configs.key_bindings.${n}"
#    )"
#    bindkey "${terminfo[$(
#        _cfg_get_string "configs.key_bindings.${n}"
#    )]}" "${n}"
#done

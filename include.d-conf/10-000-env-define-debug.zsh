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
# Set verbosity to "-5" if "quiet" config entry true or if "${QUIET}" var is set
# to true or 1.
#

if _cfg_ret_bool 'systems.dot_zsh.outs.quiet' 'true'; then
    _DZ_IO_VERBOSITY=-5
    _log_buffer 2 "--- Setting verbosity to '-05: ...... quiet' due to config"
fi

if [[ ${QUIET} -eq 1 ]] || [[ ${QUIET} == "true" ]]; then
    _DZ_IO_VERBOSITY=-5
    _log_buffer 2 \
        "--- Setting verbosity to '-05: ...... quiet' due to env var"
fi


#
# Set verbosity to "4" if "very" config entry true or if "${VERY_VERBOSE}"
# var is set to true or 1 (overwriting VERBOSE settings).
#

if _cfg_ret_bool 'systems.dot_zsh.outs.verbose'; then
    _DZ_IO_VERBOSITY=4
    _log_buffer 2 "--- Setting verbosity to '+04: very verbose' due to config"
fi

if [[ ${VERY_VERBOSE} -eq 1 ]] || [[ ${VERY_VERBOSE} == "true" ]]; then
    _DZ_IO_VERBOSITY=4
    _log_buffer 2 \
        "--- Setting verbosity to '+04: very verbose' due to env var"
fi


#
# Set verbosity to "10" if "debug" config entry true or if "${DEBUG}" var is set
# to true or 1 (overwriting VERY_VERBOSE settings).
#

if _cfg_ret_bool 'systems.dot_zsh.outs.debug'; then
    _DZ_IO_VERBOSITY=10
    _log_buffer 2 "--- Setting verbosity to '+10: ..... debug' due to config"
fi

if [[ ${DEBUG} -eq 1 ]] || [[ ${DEBUG} == "true" ]]; then
    _DZ_IO_VERBOSITY=10
    _log_buffer 2 \
        "--- Setting verbosity to '+10: ..... debug' due to env var"
fi


#
# Set verbosity to "-5" (quiet) if it hasn't been set via config or env var.
#

if [[ ! ${_DZ_IO_VERBOSITY+x} ]]; then
    _DZ_IO_VERBOSITY=-5
    _log_buffer 2 \
        "--- Setting verbosity to '-05: ...... quiet' due default assignment"
fi

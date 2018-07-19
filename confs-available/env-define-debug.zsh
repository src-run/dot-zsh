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
# Set verbosity to "-5" if "very_quiet" config entry true or if "${QUIET}" var
# is set to true or 1.
#

_try_read_conf_bool_ret 'internal.dot_zsh_settings.very_quiet' 'true' && \
    _DZ_VERBOSITY=-5 && \
    _log_buffer 2 "--- Setting verbosity to '-05: ...... quiet' due to config"

if [[ ${QUIET} -eq 1 ]] || [[ ${QUIET} == "true" ]]; then
    _DZ_VERBOSITY=-5 && \
        _log_buffer 2 \
            "--- Setting verbosity to '-05: ...... quiet' due to env var"
fi


#
# Set verbosity to "2" if "norm_verbose" config entry true or if "${VERBOSE}"
# var is set to true or 1 (overwriting QUIET settings).
#

_try_read_conf_bool_ret 'internal.dot_zsh_settings.norm_verbose' && \
    _DZ_VERBOSITY=2 && \
    _log_buffer 2 "--- Setting verbosity to '+02: .... verbose' due to config"

if [[ ${VERBOSE} -eq 1 ]] || [[ ${VERBOSE} == "true" ]]; then
    _DZ_VERBOSITY=2 && \
        _log_buffer 2 \
            "--- Setting verbosity to '+02: .... verbose' due to env var"
fi


#
# Set verbosity to "4" if "very_verbose" config entry true or if "${VERY_VERBOSE}"
# var is set to true or 1 (overwriting VERBOSE settings).
#

_try_read_conf_bool_ret 'internal.dot_zsh_settings.very_verbose' && \
    _DZ_VERBOSITY=4 && \
    _log_buffer 2 "--- Setting verbosity to '+04: very verbose' due to config"

if [[ ${VERY_VERBOSE} -eq 1 ]] || [[ ${VERY_VERBOSE} == "true" ]]; then
    _DZ_VERBOSITY=4 && \
        _log_buffer 2 \
            "--- Setting verbosity to '+04: very verbose' due to env var"
fi


#
# Set verbosity to "10" if "debug" config entry true or if "${DEBUG}" var is set
# to true or 1 (overwriting VERY_VERBOSE settings).
#

_try_read_conf_bool_ret 'internal.dot_zsh_settings.debug' && \
    _DZ_VERBOSITY=10 && \
    _log_buffer 2 "--- Setting verbosity to '+10: ..... debug' due to config"

if [[ ${DEBUG} -eq 1 ]] || [[ ${DEBUG} == "true" ]]; then
    _DZ_VERBOSITY=10 && \
        _log_buffer 2 \
            "--- Setting verbosity to '+10: ..... debug' due to env var"
fi


#
# Set verbosity to "-5" (quiet) if it hasn't been set via config or env var.
#

[[ ! ${_DZ_VERBOSITY+x} ]] && _DZ_VERBOSITY=-5 && \
    _log_buffer 2 \
        "--- Setting verbosity to '-05: ...... quiet' due default assignment"

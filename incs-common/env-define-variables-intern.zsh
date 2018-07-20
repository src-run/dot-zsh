#!/usr/bin/env zsh

#
# This file is part of the `sr`-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# File containing list of the custom directoriesto be added to environment PATH variable (if path exists)
#

_DZ_PATH_ADDITIONS_FILE="${HOME}/.path-additions.list"


#
# Temporary file containing script-requested list of the custom directoriesto be added to environment PATH variable (if path exists)
#

_DZ_PATH_SCRIPTED_FILE="${HOME}/.path-additions-scripted.list"


#
# Unset listing of all variables and functions
#

_DZ_UNSET_VS=()
_DZ_UNSET_VS+=(_DZ_SELF_WHOS)
_DZ_UNSET_VS+=(_DZ_SELF_HASH)
_DZ_UNSET_VS+=(_DZ_SELF_VERS)
_DZ_UNSET_VS+=(_DZ_SELF_REPO)
_DZ_UNSET_VS+=(_DZ_STIO_BUFF)
_DZ_UNSET_VS+=(_DZ_NAME)
_DZ_UNSET_VS+=(_DZ_PATH)
_DZ_UNSET_VS+=(_DZ_NAME)
_DZ_UNSET_VS+=(_DZ_ROOT_PATH)
_DZ_UNSET_VS+=(_DZ_LOAD_FILE)
_DZ_UNSET_VS+=(_DZ_STIO_BUFF)
_DZ_UNSET_VS+=(_DZ_INC_ENABL_PATH)
_DZ_UNSET_VS+=(_DZ_INC_AVAIL_PATH)
_DZ_UNSET_VS+=(_DZ_CFG_ENABL_PATH)
_DZ_UNSET_VS+=(_DZ_CFG_AVAIL_PATH)
_DZ_UNSET_VS+=(_DZ_BASE)
_DZ_UNSET_VS+=(_DZ_STIO_BUFF)

_DZ_UNSET_FS=()
_DZ_UNSET_FS+=(_get_unix_time_diff)
_DZ_UNSET_FS+=(_ansi_color)
_DZ_UNSET_FS+=(_ansi_clear)
_DZ_UNSET_FS+=(_style_bold)
_DZ_UNSET_FS+=(_style_dim)
_DZ_UNSET_FS+=(_style_underline)
_DZ_UNSET_FS+=(_style_blink)
_DZ_UNSET_FS+=(_style_invert)
_DZ_UNSET_FS+=(_style_hide)
_DZ_UNSET_FS+=(_style_strikeout)
_DZ_UNSET_FS+=(_fg_default)
_DZ_UNSET_FS+=(_fg_black)
_DZ_UNSET_FS+=(_fg_red)
_DZ_UNSET_FS+=(_fg_green)
_DZ_UNSET_FS+=(_fg_yellow)
_DZ_UNSET_FS+=(_fg_blue)
_DZ_UNSET_FS+=(_fg_magenta)
_DZ_UNSET_FS+=(_fg_cyan)
_DZ_UNSET_FS+=(_fg_light_gray)
_DZ_UNSET_FS+=(_fg_dark_gray)
_DZ_UNSET_FS+=(_fg_light_red)
_DZ_UNSET_FS+=(_fg_light_green)
_DZ_UNSET_FS+=(_fg_light_yellow)
_DZ_UNSET_FS+=(_fg_light_blue)
_DZ_UNSET_FS+=(_fg_light_magenta)
_DZ_UNSET_FS+=(_fg_light_cyan)
_DZ_UNSET_FS+=(_fg_white)
_DZ_UNSET_FS+=(_bg_default)
_DZ_UNSET_FS+=(_bg_black)
_DZ_UNSET_FS+=(_bg_red)
_DZ_UNSET_FS+=(_bg_green)
_DZ_UNSET_FS+=(_bg_yellow)
_DZ_UNSET_FS+=(_bg_blue)
_DZ_UNSET_FS+=(_bg_magenta)
_DZ_UNSET_FS+=(_bg_cyan)
_DZ_UNSET_FS+=(_bg_light_gray)
_DZ_UNSET_FS+=(_bg_dark_gray)
_DZ_UNSET_FS+=(_bg_light_red)
_DZ_UNSET_FS+=(_bg_light_green)
_DZ_UNSET_FS+=(_bg_light_yellow)
_DZ_UNSET_FS+=(_bg_light_blue)
_DZ_UNSET_FS+=(_bg_light_magenta)
_DZ_UNSET_FS+=(_bg_light_cyan)
_DZ_UNSET_FS+=(_bg_white)
_DZ_UNSET_FS+=(_ansi_rm_sgr_el)
_DZ_UNSET_FS+=(_wrt_log)
_DZ_UNSET_FS+=(_log_normal)
_DZ_UNSET_FS+=(_out_indent)
_DZ_UNSET_FS+=(_self_repo_parse_path)
_DZ_UNSET_FS+=(_self_repo_parse_remote)
_DZ_UNSET_FS+=(_self_repo_parse_is_dirty)
_DZ_UNSET_FS+=(_self_repo_parse_branch)
_DZ_UNSET_FS+=(_self_repo_parse_hash)
_DZ_UNSET_FS+=(_self_repo_parse_tag)
_DZ_UNSET_FS+=(_self_repo_repo)
_DZ_UNSET_FS+=(_self_repo_whos)
_DZ_UNSET_FS+=(_self_repo_tag)
_DZ_UNSET_FS+=(_self_repo_vers)
_DZ_UNSET_FS+=(_self_repo_hash)
_DZ_UNSET_FS+=(_self_repo_load)
_DZ_UNSET_FS+=(_parse_shell_path)
_DZ_UNSET_FS+=(_parse_zsh_path)
_DZ_UNSET_FS+=(_parse_zsh_version)
_DZ_UNSET_FS+=(_profiler_get_precise_time)
_DZ_UNSET_FS+=(_profiler_clear)
_DZ_UNSET_FS+=(_profiler_begin)
_DZ_UNSET_FS+=(_profiler_close)
_DZ_UNSET_FS+=(_profiler_diff)
_DZ_UNSET_FS+=(_wrt_completion_summary)
_DZ_UNSET_FS+=(_log_source)
_DZ_UNSET_FS+=(_log_action)
_DZ_UNSET_FS+=(_log_warn)
_DZ_UNSET_FS+=(_add_env_path_dir)
_DZ_UNSET_FS+=(_add_env_path_dir_temp)
_DZ_UNSET_FS+=(_clean_env_path_dir_temp)
_DZ_UNSET_FS+=(_aliases_setup_ssh_connections)
_DZ_UNSET_FS+=(_aliases_build_ssh_command)

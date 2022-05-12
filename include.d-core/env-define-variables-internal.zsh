#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


##
## OH-MY-ZSH CONFIGURATION
##


#
# location of oh my zsh installation
#
_OH_ROOT_PATH="${HOME}/.oh-my-zsh"
_OH_LOAD_PATH="${_OH_ROOT_PATH}/oh-my-zsh.sh"


##
## OH-MY-ZSH LOADER
##


#
# Define config, loader, and user-json-config include paths.
#

_DZ_INC_CONF_PATH="${_DZ_PATH}/include.d-conf"
_DZ_INC_LOAD_PATH="${_DZ_PATH}/include.d-load"
_DZ_INC_JSON_PATH="${HOME}/.dot-zsh.json"
_DZ_DEF_JSON_PATH="${_DZ_PATH}/dot-zsh.json"


##
## INTERNAL CONFIGURATION
##

#
# Names of up/down key commands for history-substring-search plug-in.
#

_DZ_PLUG_HIST_SUB_SRCH_KEY_COMMANDS=('history-substring-search-up' 'history-substring-search-down')


#
# File containing list of the custom directoriesto be added to environment PATH variable (if path exists)
#

_DZ_PATH_ADDITIONS_FILE="${HOME}/.path-additions.list"


#
# Temporary file containing script-requested list of the custom directories to be added to environment PATH variable (if path exists)
#

_DZ_PATH_SCRIPTED_FILE="${HOME}/.path-additions-scripted.list"


#
# Temporary file for output buffering
#
_DZ_PATH_OUT_BUFFERING="/tmp/dot-zsh-buffer_${RANDOM}.out"


#
# Unset listing of all variables
#

_DZ_UNSET_VS=()
_DZ_UNSET_VS+=("_DZ_BASE")
_DZ_UNSET_VS+=("_DZ_EDITOR_NAME")
_DZ_UNSET_VS+=("_DZ_EDITOR_PATH")
_DZ_UNSET_VS+=("_DZ_GIT_REMOTE")
_DZ_UNSET_VS+=("_DZ_IFS_PRIOR")
_DZ_UNSET_VS+=("_DZ_INC_CONF_PATH")
_DZ_UNSET_VS+=("_DZ_INC_CORE_SRCS")
_DZ_UNSET_VS+=("_DZ_INC_JSON_PATH")
_DZ_UNSET_VS+=("_DZ_INC_JSON_PATH_CONTENTS")
_DZ_UNSET_VS+=("_DZ_INC_LOAD_PATH")
_DZ_UNSET_VS+=("_DZ_IO_BUFFERING")
_DZ_UNSET_VS+=("_DZ_IO_BUFF_DEFINITION_INDENT")
_DZ_UNSET_VS+=("_DZ_IO_BUFF_DEFINITION_PREFIX")
_DZ_UNSET_VS+=("_DZ_IO_BUFF_DEFINITION_VALUES")
_DZ_UNSET_VS+=("_DZ_IO_BUFF_LINES")
_DZ_UNSET_VS+=("_DZ_IO_BUFF_NORM")
_DZ_UNSET_VS+=("_DZ_IO_VERBOSITY")
_DZ_UNSET_VS+=("_DZ_LOAD_PATH")
_DZ_UNSET_VS+=("_DZ_LOAD_TIME")
_DZ_UNSET_VS+=("_DZ_LOGS_PATH")
_DZ_UNSET_VS+=("_DZ_LOG_BUFFER_LINES")
_DZ_UNSET_VS+=("_DZ_MAN_PATH_DEFAULTS")
_DZ_UNSET_VS+=("_DZ_MAN_PATH_ORIGINAL")
_DZ_UNSET_VS+=("_DZ_MAN_PATH_TO_APPLY")
_DZ_UNSET_VS+=("_DZ_NAME")
_DZ_UNSET_VS+=("_DZ_NPM_MANPAGES_PATH")
_DZ_UNSET_VS+=("_DZ_PATH")
_DZ_UNSET_VS+=("_DZ_PATH_ADDITIONS_FILE")
_DZ_UNSET_VS+=("_DZ_PATH_DELIMITER")
_DZ_UNSET_VS+=("_DZ_PATH_SCRIPTED_FILE")
_DZ_UNSET_VS+=("_DZ_SELF_COMMIT")
_DZ_UNSET_VS+=("_DZ_SELF_GIT_BRANCH")
_DZ_UNSET_VS+=("_DZ_SELF_HASH")
_DZ_UNSET_VS+=("_DZ_SELF_REPO")
_DZ_UNSET_VS+=("_DZ_SELF_TAG")
_DZ_UNSET_VS+=("_DZ_SELF_VERS")
_DZ_UNSET_VS+=("_DZ_SELF_WHOS")
_DZ_UNSET_VS+=("_DZ_ZSH_PATH")
_DZ_UNSET_VS+=("_DZ_ZSH_VERSION")
_DZ_UNSET_VS+=("_OH_LOAD_PATH")
_DZ_UNSET_VS+=("_OH_ROOT_PATH")
_DZ_UNSET_VS+=("_ZSH_GIT_REMOTE")
_DZ_UNSET_VS+=("_ZSH_INSTALL_TO")


#
# Unset listing of all functions
#

_DZ_UNSET_FS=()
_DZ_UNSET_FS+=("_buf_definition_list")
_DZ_UNSET_FS+=("_add_env_path_dir")
_DZ_UNSET_FS+=("_aliases_build_ssh_command")
_DZ_UNSET_FS+=("_aliases_setup_ssh_connections")
_DZ_UNSET_FS+=("_o_ansi_clear")
_DZ_UNSET_FS+=("_ansi_color")
_DZ_UNSET_FS+=("_o_ansi_al_sequence_remove")
_DZ_UNSET_FS+=("_o_bg_black")
_DZ_UNSET_FS+=("_o_bg_blue")
_DZ_UNSET_FS+=("_o_bg_cyan")
_DZ_UNSET_FS+=("_o_bg_dark_gray")
_DZ_UNSET_FS+=("_o_bg_default")
_DZ_UNSET_FS+=("_o_bg_green")
_DZ_UNSET_FS+=("_o_bg_light_blue")
_DZ_UNSET_FS+=("_o_bg_light_cyan")
_DZ_UNSET_FS+=("_o_bg_light_gray")
_DZ_UNSET_FS+=("_o_bg_light_green")
_DZ_UNSET_FS+=("_o_bg_light_magenta")
_DZ_UNSET_FS+=("_o_bg_light_red")
_DZ_UNSET_FS+=("_o_bg_light_yellow")
_DZ_UNSET_FS+=("_o_bg_magenta")
_DZ_UNSET_FS+=("_o_bg_red")
_DZ_UNSET_FS+=("_o_bg_white")
_DZ_UNSET_FS+=("_o_bg_yellow")
_DZ_UNSET_FS+=("_check_extern_source_file")
_DZ_UNSET_FS+=("_check_extern_source_file_enabled")
_DZ_UNSET_FS+=("_get_definition_list_line")
_DZ_UNSET_FS+=("_cfg_get_array_assoc")
_DZ_UNSET_FS+=("_cfg_get_array_values")
_DZ_UNSET_FS+=("_cfg_req_array_values")
_DZ_UNSET_FS+=("_cfg_get_bool")
_DZ_UNSET_FS+=("_cfg_get_json_contents")
_DZ_UNSET_FS+=("_cfg_get_cached_key")
_DZ_UNSET_FS+=("_cfg_get_cached_val_type")
_DZ_UNSET_FS+=("_cfg_get_cached_val")
_DZ_UNSET_FS+=("_cfg_get_number")
_DZ_UNSET_FS+=("_cfg_get_string")
_DZ_UNSET_FS+=("_cfg_req_string")
_DZ_UNSET_FS+=("_cfg_resolve_array")
_DZ_UNSET_FS+=("_cfg_resolve_string")
_DZ_UNSET_FS+=("_cfg_ret_bool")
_DZ_UNSET_FS+=("_o_fg_black")
_DZ_UNSET_FS+=("_o_fg_blue")
_DZ_UNSET_FS+=("_o_fg_cyan")
_DZ_UNSET_FS+=("_o_fg_dark_gray")
_DZ_UNSET_FS+=("_o_fg_default")
_DZ_UNSET_FS+=("_o_fg_green")
_DZ_UNSET_FS+=("_o_fg_light_blue")
_DZ_UNSET_FS+=("_o_fg_light_cyan")
_DZ_UNSET_FS+=("_o_fg_light_gray")
_DZ_UNSET_FS+=("_o_fg_light_green")
_DZ_UNSET_FS+=("_o_fg_light_magenta")
_DZ_UNSET_FS+=("_o_fg_light_red")
_DZ_UNSET_FS+=("_o_fg_light_yellow")
_DZ_UNSET_FS+=("_o_fg_magenta")
_DZ_UNSET_FS+=("_o_fg_red")
_DZ_UNSET_FS+=("_o_fg_white")
_DZ_UNSET_FS+=("_o_fg_yellow")
_DZ_UNSET_FS+=("_flatten_lines")
_DZ_UNSET_FS+=("_get_array_key")
_DZ_UNSET_FS+=("_get_array_val")
_DZ_UNSET_FS+=("_get_unix_time_diff")
_DZ_UNSET_FS+=("_ifs_newlines")
_DZ_UNSET_FS+=("_ifs_reset")
_DZ_UNSET_FS+=("_log_definition_list")
_DZ_UNSET_FS+=("_log_action")
_DZ_UNSET_FS+=("_buf_flush_lines")
_DZ_UNSET_FS+=("_log_crit")
_DZ_UNSET_FS+=("_log_norm")
_DZ_UNSET_FS+=("_log_source")
_DZ_UNSET_FS+=("_log_src_done")
_DZ_UNSET_FS+=("_log_src_fail")
_DZ_UNSET_FS+=("_log_src_skip")
_DZ_UNSET_FS+=("_log_warn")
_DZ_UNSET_FS+=("_parse_shell_path")
_DZ_UNSET_FS+=("_parse_zsh_path")
_DZ_UNSET_FS+=("_parse_zsh_version")
_DZ_UNSET_FS+=("_printf_log_src")
_DZ_UNSET_FS+=("_profiler_begin")
_DZ_UNSET_FS+=("_profiler_clear")
_DZ_UNSET_FS+=("_profiler_close")
_DZ_UNSET_FS+=("_profiler_diff")
_DZ_UNSET_FS+=("_profiler_get_precise_time")
_DZ_UNSET_FS+=("_resolve_value_type")
_DZ_UNSET_FS+=("_self_repo_hash")
_DZ_UNSET_FS+=("_self_repo_load")
_DZ_UNSET_FS+=("_self_repo_parse_branch")
_DZ_UNSET_FS+=("_self_repo_parse_hash")
_DZ_UNSET_FS+=("_self_repo_parse_is_dirty")
_DZ_UNSET_FS+=("_self_repo_parse_path")
_DZ_UNSET_FS+=("_self_repo_parse_remote")
_DZ_UNSET_FS+=("_self_repo_parse_tag")
_DZ_UNSET_FS+=("_self_repo_repo")
_DZ_UNSET_FS+=("_self_repo_tag")
_DZ_UNSET_FS+=("_self_repo_vers")
_DZ_UNSET_FS+=("_self_repo_whos")
_DZ_UNSET_FS+=("_o_style_blink")
_DZ_UNSET_FS+=("_o_style_bold")
_DZ_UNSET_FS+=("_o_style_dim")
_DZ_UNSET_FS+=("_o_style_hide")
_DZ_UNSET_FS+=("_o_style_invert")
_DZ_UNSET_FS+=("_o_style_strikeout")
_DZ_UNSET_FS+=("_o_style_underline")
_DZ_UNSET_FS+=("_trim_line_width")
_DZ_UNSET_FS+=("_wrt_log")

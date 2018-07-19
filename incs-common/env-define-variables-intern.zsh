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
# Paths for cd environment variable
#

_DZ_CHANGE_DIR_PATHS=()

#
# List of the default directories to be added to environment PATH variable (if path exists)
#

_DZ_PATH_ADDITIONS_LIST=("${HOME}/bin" "${HOME}/scripts" "${HOME}/scripts/bin-enabled")


#
# File containing list of the custom directoriesto be added to environment PATH variable (if path exists)
#

_DZ_PATH_ADDITIONS_FILE="${HOME}/.path-additions.list"


#
# Temporary file containing script-requested list of the custom directoriesto be added to environment PATH variable (if path exists)
#

_DZ_PATH_SCRIPTED_FILE="${HOME}/.path-additions-scripted.list"


#
# Define our list of variable to export.
#

typeset -a _DZ_LIST_EXPORT
_DZ_LIST_EXPORT=(ZSH PATH LANG EDITOR SSH_KEY_PATH)

#
# Define android sdk path
#

_DZ_ANDROID_SDK_BIN_PATH="${HOME}/Android/Sdk/platform-tools"


#
# Travis shell completion file
#

_DZ_TRAVIS_SHELL_COMPLETION="${HOME}/.travis/travis.sh"


#
# composer configuration
#

_DZ_GLOBAL_COMPOSER_BIN="${HOME}/.config/composer/vendor/bin"


#
# platform.sh configuration
#

_DZ_PLATFORM_SH_BIN="${HOME}/.platformsh/bin"
_DZ_PLATFORM_SH_SHELL_CONFIG="${HOME}/.platformsh/shell-config.rc"


#
# phpenv configuration
#

_DZ_PHPENV_ROOT="${HOME}/.phpenv"
_DZ_PHPENV_BIN="${_DZ_PHPENV_ROOT}/bin"
_DZ_PHPENV_COMPLETIONS="${_DZ_PHPENV_ROOT}/completions/rbenv.zsh"


#
# NPM configuration
#

_DZ_NPM_PACKAGES_PATH="${HOME}/.npm-packages"
_DZ_NPM_MANPAGES_PATH="${_DZ_NPM_PACKAGES_PATH}/share/man"


#
# google cloud configuration
#

_DZ_GCLOUD_PATH_FILE="/opt/google-cloud-sdk/path.zsh.inc"
_DZ_GCLOUD_SHELL_COMPLETION="/opt/google-cloud-sdk/completion.zsh.inc"


#
# golang configuration
#
GOROOT="${HOME}/golang/1.9"


#
# gpg configuration
#
_DZ_GNUPG_KEY="466839F8117362D877E438BE02B8697CE6AA381A"


#
# docker configuration
#

_DZ_DOCKER_ENVIRONMENT="default"


#
# chruby configuration
#

_DZ_CHRUBY_ENVIRONMENT="/usr/local/share/chruby/chruby.sh"
_DZ_CHRUBY_AUTO_SELECT="/usr/local/share/chruby/auto.sh"


#
# apt-fast configuration
#

_DZ_APT_FAST_COMPLETION="/usr/share/zsh/functions/Completion/Debian/_apt-fast"


#
# Define out alias list and optional options
#

typeset -A _DZ_SSH_ALIAS_USER
typeset -A _DZ_SSH_ALIAS_HOST
typeset -A _DZ_SSH_ALIAS_PORT
typeset -A _DZ_SSH_ALIAS_OPTS
typeset -A _DZ_SSH_ALIAS_WAIT

_DZ_SSH_ALIAS_USER[obes]="rmf"
_DZ_SSH_ALIAS_HOST[obes]="obes.rmf.systems"
_DZ_SSH_ALIAS_PORT[obes]=2222

_DZ_SSH_ALIAS_USER[twoface]="rmf"
_DZ_SSH_ALIAS_HOST[twoface]="twoface.rmf.systems"

_DZ_SSH_ALIAS_USER[sr]="rmf"
_DZ_SSH_ALIAS_HOST[sr]="src.run"

_DZ_SSH_ALIAS_USER[sp]="rmf"
_DZ_SSH_ALIAS_HOST[sp]="silverpapillon.com"


#
# Simple aliases
#

typeset -A _DZ_ALIAS_LIST

_DZ_ALIAS_LIST[ccat]='pygmentize -g'
_DZ_ALIAS_LIST[vcat]='pygmentize -g -O style=colorful,linenos=1'
_DZ_ALIAS_LIST[gpg]='gpg2'


#
# Unset listing of all variables and functions
#

_DZ_UNSET_VS=(_DZ_SELF_WHOS _DZ_SELF_HASH _DZ_SELF_VERS _DZ_SELF_REPO _DZ_STIO_BUFF _DZ_NAME _DZ_PATH _DZ_NAME _DZ_ROOT_PATH _DZ_LOAD_FILE _DZ_STIO_BUFF _DZ_INC_ENABL_PATH _DZ_INC_AVAIL_PATH _DZ_CFG_ENABL_PATH _DZ_CFG_AVAIL_PATH _DZ_BASE _DZ_STIO_BUFF _DZ_LIST_ALIAS _DZ_OPTS_ALIAS _DZ_LIST_EXPORT _DZ_LIST_ALIAS_NAME _DZ_LIST_ALIAS_CMDS)
_DZ_UNSET_FS=( _get_unix_time_diff _ansi_color _ansi_clear _style_bold _style_dim _style_underline _style_blink _style_invert _style_hide _style_strikeout _fg_default _fg_black _fg_red _fg_green _fg_yellow _fg_blue _fg_magenta _fg_cyan _fg_light_gray _fg_dark_gray _fg_light_red _fg_light_green _fg_light_yellow _fg_light_blue _fg_light_magenta _fg_light_cyan _fg_white _bg_default _bg_black _bg_red _bg_green _bg_yellow _bg_blue _bg_magenta _bg_cyan _bg_light_gray _bg_dark_gray _bg_light_red _bg_light_green _bg_light_yellow _bg_light_blue _bg_light_magenta _bg_light_cyan _bg_white _ansi_rm_sgr_el _wrt_log _log_normal _out_indent _self_repo_parse_path _self_repo_parse_remote _self_repo_parse_is_dirty _self_repo_parse_branch _self_repo_parse_hash _self_repo_parse_tag _self_repo_repo _self_repo_whos _self_repo_tag _self_repo_vers _self_repo_hash _self_repo_load _parse_shell_path _parse_zsh_path _parse_zsh_version _profiler_get_precise_time _profiler_clear _profiler_begin _profiler_close _profiler_diff _wrt_completion_summary _log_source _log_action _log_warn _add_env_path_dir _add_env_path_dir_temp _clean_env_path_dir_temp _aliases_setup_ssh_connections _aliases_build_ssh_command)


# EOF

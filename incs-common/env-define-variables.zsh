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
# List of the default directories to be added to environment PATH variable (if path exists)
#

D_ZSH_PATH_ADDITIONS_LIST=("${HOME}/bin" "${HOME}/scripts" "${HOME}/scripts/bin-enabled")


#
# File containing list of the custom directoriesto be added to environment PATH variable (if path exists)
#

D_ZSH_PATH_ADDITIONS_FILE="${HOME}/.path-additions.list"


#
# Temporary file containing script-requested list of the custom directoriesto be added to environment PATH variable (if path exists)
#

D_ZSH_PATH_SCRIPTED_FILE="${HOME}/.path-additions-scripted.list"


#
# Define our list of variable to export.
#

typeset -a D_ZSH_LIST_EXPORT
D_ZSH_LIST_EXPORT=(ZSH PATH LANG EDITOR SSH_KEY_PATH)

#
# Define android sdk path
#

D_ZSH_ANDROID_SDK_BIN_PATH="${HOME}/Android/Sdk/platform-tools"


#
# Travis shell completion file
#

D_ZSH_TRAVIS_SHELL_COMPLETION="${HOME}/.travis/travis.sh"


#
# composer configuration
#

D_ZSH_GLOBAL_COMPOSER_BIN="${HOME}/.config/composer/vendor/bin"


#
# platform.sh configuration
#

D_ZSH_PLATFORM_SH_BIN="${HOME}/.platformsh/bin"
D_ZSH_PLATFORM_SH_SHELL_CONFIG="${HOME}/.platformsh/shell-config.rc"


#
# phpenv configuration
#

_DOT_ZSH_PHPENV_ROOT="${HOME}/.phpenv"
_DOT_ZSH_PHPENV_BIN="${_DOT_ZSH_PHPENV_ROOT}/bin"
_DOT_ZSH_PHPENV_COMPLETIONS="${_DOT_ZSH_PHPENV_ROOT}/completions/rbenv.zsh"


#
# NPM configuration
#

D_ZSH_NPM_PACKAGES_PATH="${HOME}/.npm-packages"
D_ZSH_NPM_MANPAGES_PATH="${D_ZSH_NPM_PACKAGES_PATH}/share/man"


#
# google cloud configuration
#

D_ZSH_GCLOUD_PATH_FILE="/opt/google-cloud-sdk/path.zsh.inc"
D_ZSH_GCLOUD_SHELL_COMPLETION="/opt/google-cloud-sdk/completion.zsh.inc"


#
# golang configuration
#
GOROOT="${HOME}/golang/1.9"


#
# gpg configuration
#
D_ZSH_GNUPG_KEY="466839F8117362D877E438BE02B8697CE6AA381A"


#
# docker configuration
#

D_ZSH_DOCKER_ENVIRONMENT="default"


#
# chruby configuration
#

D_ZSH_CHRUBY_ENVIRONMENT="/usr/local/share/chruby/chruby.sh"
D_ZSH_CHRUBY_AUTO_SELECT="/usr/local/share/chruby/auto.sh"


#
# apt-fast configuration
#

D_ZSH_APT_FAST_COMPLETION="/usr/share/zsh/functions/Completion/Debian/_apt-fast"


#
# Define out alias list and optional options
#

typeset -A D_ZSH_SSH_ALIAS_USER
typeset -A D_ZSH_SSH_ALIAS_HOST
typeset -A D_ZSH_SSH_ALIAS_PORT
typeset -A D_ZSH_SSH_ALIAS_OPTS
typeset -A D_ZSH_SSH_ALIAS_WAIT

D_ZSH_SSH_ALIAS_USER[obes]="rmf"
D_ZSH_SSH_ALIAS_HOST[obes]="obes.rmf.systems"
D_ZSH_SSH_ALIAS_PORT[obes]=2222

D_ZSH_SSH_ALIAS_USER[twoface]="rmf"
D_ZSH_SSH_ALIAS_HOST[twoface]="twoface.rmf.systems"

D_ZSH_SSH_ALIAS_USER[sr]="rmf"
D_ZSH_SSH_ALIAS_HOST[sr]="src.run"

D_ZSH_SSH_ALIAS_USER[sp]="rmf"
D_ZSH_SSH_ALIAS_HOST[sp]="silverpapillon.com"


#
# Simple aliases
#

typeset -A D_ZSH_ALIAS_LIST

D_ZSH_ALIAS_LIST[ccat]='pygmentize -g'
D_ZSH_ALIAS_LIST[vcat]='pygmentize -g -O style=colorful,linenos=1'
D_ZSH_ALIAS_LIST[gpg]='gpg2'


#
# Unset listing of all variables and functions
#

D_ZSH_UNSET_VS=(D_ZSH_SELF_WHOS D_ZSH_SELF_HASH D_ZSH_SELF_VERS D_ZSH_SELF_REPO D_ZSH_STIO_BUFF D_ZSH_NAME D_ZSH_PATH D_ZSH_NAME D_ZSH_ROOT_PATH D_ZSH_LOAD_FILE D_ZSH_STIO_BUFF D_ZSH_INC_ENABL_PATH D_ZSH_INC_AVAIL_PATH D_ZSH_CFG_ENABL_PATH D_ZSH_CFG_AVAIL_PATH D_ZSH_BASE D_ZSH_STIO_BUFF D_ZSH_LIST_ALIAS D_ZSH_OPTS_ALIAS D_ZSH_LIST_EXPORT D_ZSH_LIST_ALIAS_NAME D_ZSH_LIST_ALIAS_CMDS)
D_ZSH_UNSET_FS=( _getDifferenceBetweenUnixTimes _ansiColor _ansiClear _styleBold _styleDim _styleUnderline _styleBlink _styleInvert _styleHide _styleStrikeout _fgDefault _fgBlack _fgRed _fgGreen _fgYellow _fgBlue _fgMagenta _fgCyan _fgLightGray _fgDarkGray _fgLightRed _fgLightGreen _fgLightYellow _fgLightBlue _fgLightMagenta _fgLightCyan _fgWhite _bgDefault _bgBlack _bgRed _bgGreen _bgYellow _bgBlue _bgMagenta _bgCyan _bgLightGray _bgDarkGray _bgLightRed _bgLightGreen _bgLightYellow _bgLightBlue _bgLightMagenta _bgLightCyan _bgWhite _rmAnsiSgrEl _wrtLog _topLog _indent _dzsh_warning _dotZshRepoByPath _dotZshRepoByRemote _dotZshParseGitDirty _dotZshParseGitBranch _dotZshParseGitHash _dotZshParseGitTag _dotZshRepo _dotZshWhos _dotZshTag _dotZshVers _dotZshHash _dotZshLoad _dotZshParseShellPath _dotZshParseZshPath _dotZshParseZshVers _profGetPrecTime _profClear _profStart _profEnd _profDiff _dotZshWriteFancyComplete _incLog _actLog _warning _dotZshPathVariableAddition _dotZshPathVariableAdditionRequest _dotZshPathVariableAdditionRequestCleanup _dotZshSshAliasAssigments _dotZshSshAliasBuildCommand)


# EOF

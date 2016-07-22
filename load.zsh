#!/usr/bin/zsh


#
# Paths of this script
#

_DOTZSH_LOADER_PATHNAME="$HOME/.dot"
_DOTZSH_LOADER_FILENAME="`basename ${(%):-%x}`"
_DOTZSH_LOADER_FILEPATH="$_DOTZSH_LOADER_PATHNAME/$_DOTZSH_LOADER_FILENAME"
_DOTZSH_CONFIG_FILEPATHS=("$_DOTZSH_LOADER_PATHNAME/conf.zsh")


#
# Configure debug mode
#

if [[ ${_DOTZSH_DEBUG+x} ]]; then set -x; fi


#
# Configure verbosity
#

if [[ ! ${_DOTZSH_VERBOSITY+x} ]]; then _DOTZSH_VERBOSITY=0; fi


#
# The echo function sucks; this is better.
#

function zprintf() {
  local -i verbosity
  local context
  local message

  verbosity=$1
  context=$2
  message=$3

  shift ; shift ; shift

  (( _DOTZSH_VERBOSITY < verbosity )) && return 0

  printf "[$(date +%s):%02d:%s] ${message}\n" ${verbosity} ${context} "$@"
}


#
# Init
#

zprintf 2 "$_DOTZSH_LOADER_FILEPATH" 'Initializing "src-run/dot-zsh" ...'
zprintf 2 "$_DOTZSH_LOADER_FILEPATH" ' LOADER  : %s' "$_DOTZSH_LOADER_FILENAME"
zprintf 2 "$_DOTZSH_LOADER_FILEPATH" ' SHELL   : zsh'
zprintf 2 "$_DOTZSH_LOADER_FILEPATH" ' VERSION : %s' "$ZSH_VERSION"


#
# Source configuration files.
#

zprintf 1 "$_DOTZSH_LOADER_FILEPATH" "Loading configuration file(s) ..."

for configFilePath in "${_DOTZSH_CONFIG_FILEPATHS[@]}"
do
  if [[ ! -f "$configFilePath" ]]
  then
    zprintf 1 "$_DOTZSH_LOADER_FILEPATH" "Aboring due to failed config include: $configFilePath"
    exit -1
  fi

  zprintf 1 "$_DOTZSH_LOADER_FILEPATH" " - $configFilePath"
  source $configFilePath
done


#
# Source all enabled includes by int-prefix order.
#

zprintf 1 "$_DOTZSH_LOADER_FILEPATH" "Loading enabled include(s) ..."

for includeFilePath in $DOT_FILES_INCS_ENABLED/???-*.zsh
do
  if [[ ! -f "$includeFilePath" ]]
  then
    zprintf 1 "$_DOTZSH_LOADER_FILEPATH" "Continuing despite failed include: $includeFilePath"
    continue
  fi

  zprintf 1 "$_DOTZSH_LOADER_FILEPATH" " - $includeFilePath"
  source "$includeFilePath"
done

unset includeFilePath


#
# cleanup
#

zprintf 2 "$_DOTZSH_LOADER_FILEPATH" "Cleaning up temporary funcs/vars ..."

unset _DOTZSH_LOADER_PATHNAME
unset _DOTZSH_LOADER_FILENAME
unset _DOTZSH_LOADER_FILEPATH
unset _DOTZSH_CONFIG_FILEPATHS

# EOF

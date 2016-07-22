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
# Define out alias list and optional options
#

typeset -A _DOT_ZSH_ALIAS_LIST
typeset -A _DOT_ZSH_ALIAS_OPTS

_DOT_ZSH_ALIAS_LIST[obes]="172.16.0.210"
_DOT_ZSH_ALIAS_LIST[sr]="src.run"
_DOT_ZSH_ALIAS_LIST[rmf-001]="104.154.65.106"
_DOT_ZSH_ALIAS_LIST[obes-remote]="108.2.193.83"
_DOT_ZSH_ALIAS_OPTS[obes-remote]="-p 49716"


#
# Define function to setup and assign the aliases via the configured variables
#

function _DOT_ZSH_setup_aliases()
{
  local host
  local name
  local name_full
  local prefix=( "ssh-" )
  local cmd
  local template="\\n #\\n # [ SSH Alias Configuration Resolver ]\\n #\\n # - NAME: "%s"\\n # - USER: "%s"\\n # - HOST: "%s"\\n # - OPTS: "%s"\\n #\\n # Establishing connection...\\n #\\n\\n ---\\n"

  for k in "${(@k)_DOT_ZSH_ALIAS_LIST}"; do
    name="${k}"
    host="${_DOT_ZSH_ALIAS_LIST[$k]}"
    cmd="${USER}@${host}"
    opt=""

    if [[ "${_DOT_ZSH_ALIAS_OPTS[$name]}" != "" ]]; then
        opt="${_DOT_ZSH_ALIAS_OPTS[$name]}"
    fi

    if [[ "$opt" == "" ]]; then
      opt_str="null"
    else
      opt_str="$opt"
    fi

    if [[ "$opt" != "" ]] && [[ "${opt:0:1}" != " " ]]; then
      opt="${opt} "
    fi

    for pre in "${prefix[@]}"; do
      which "${cmd}" > /dev/null
      if [[ "$?" -eq "1" ]]; then
        name_full="${pre}${name}"
        
        alias $name_full="clear ; sleep .33 ; echo '$(printf $template "${name}" "$USER" "${host}" "${opt_str}")' ; echo '' ; ssh $opt$cmd"
        _writeIncludeLog 3 "Defined alias ${name_full}=\"ssh ${opt}${cmd}\""
      fi
    done
  done
}


#
# Do it!
#

_DOT_ZSH_setup_aliases


#
# Clean up our left-over vars
#

unset _DOT_ZSH_setup_aliases
unset _DOT_ZSH_ALIAS_LIST
unset _DOT_ZSH_ALIAS_OPTS

# EOF

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

typeset -A D_ZSH_LIST_ALIAS
typeset -A D_ZSH_OPTS_ALIAS

D_ZSH_LIST_ALIAS[obes]="172.16.0.210"
D_ZSH_LIST_ALIAS[sr]="src.run"
D_ZSH_LIST_ALIAS[rmf-001]="104.154.65.106"
D_ZSH_LIST_ALIAS[obes-remote]="108.2.193.83"
D_ZSH_OPTS_ALIAS[obes-remote]="-p 49716"


#
# Define function to setup and assign the aliases via the configured variables
#

function _dotZshAliasSSH() {
  local host
  local name
  local name_full
  local prefix=( "ssh-" )
  local cmd
  local template="\\n #\\n # [ SSH Alias Configuration Resolver ]\\n #\\n # - NAME: "%s"\\n # - USER: "%s"\\n # - HOST: "%s"\\n # - OPTS: "%s"\\n #\\n # Establishing connection...\\n #\\n\\n ---\\n"

  for k in "${(@k)D_ZSH_LIST_ALIAS}"; do
    name="${k}"
    host="${D_ZSH_LIST_ALIAS[$k]}"
    cmd="${USER}@${host}"
    opt=""

    if [[ "${D_ZSH_OPTS_ALIAS[$name]}" != "" ]]; then
        opt="${D_ZSH_OPTS_ALIAS[$name]}"
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
        _incLog 2 3 "Alias defined '${name_full}=\"ssh ${opt}${cmd}\"'"
      fi
    done
  done
}


#
# Do it!
#

_dotZshAliasSSH


# EOF

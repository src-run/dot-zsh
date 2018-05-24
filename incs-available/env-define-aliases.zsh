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
typeset -A D_ZSH_USER_ALIAS

D_ZSH_LIST_ALIAS[obes]="obes.rmf.systems"
D_ZSH_OPTS_ALIAS[obes]="-p 2222"
D_ZSH_LIST_ALIAS[twoface]="twoface.rmf.systems"
D_ZSH_LIST_ALIAS[sr]="src.run"
D_ZSH_LIST_ALIAS[sp]="silverpapillon.com"


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
    cmd="${host}"
    opt=""
    usr="rmf"

    if [[ "${D_ZSH_OPTS_ALIAS[$name]}" != "" ]]; then
        opt="${D_ZSH_OPTS_ALIAS[$name]}"
    fi

    if [[ "${D_ZSH_USER_ALIAS[$name]}" != "" ]]; then
        usr="${D_ZSH_USER_ALIAS[$name]}"
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

        alias $name_full="clear ; sleep .33 ; echo '$(printf $template "${name}" "$usr" "${host}" "${opt_str}")' ; echo '' ; ssh -l${usr} $opt$cmd" &> /dev/null \
          && _actLog "Alias defined '${name_full}=\"ssh -l${usr} ${opt}${cmd}\"'" \
          || _dzsh_warning "Failed to define alias '${name_full}=\"ssh -l${usr} ${opt}${cmd}\"'"
      fi
    done
  done
}


#
# Do it!
#

_dotZshAliasSSH


#
# Simple aliases
#

unset D_ZSH_LIST_ALIAS
typeset -A D_ZSH_LIST_ALIAS

D_ZSH_LIST_ALIAS[ccat]='pygmentize -g'
D_ZSH_LIST_ALIAS[vcat]='pygmentize -g -O style=colorful,linenos=1'
D_ZSH_LIST_ALIAS[gpg]='gpg2'


#
# Apply simple aliases.
#

for n in "${(@k)D_ZSH_LIST_ALIAS}"; do
  alias $n="${D_ZSH_LIST_ALIAS[$n]}"
  _actLog "Alias defined '${n}=\"${D_ZSH_LIST_ALIAS[$n]}\"'"
done


# EOF

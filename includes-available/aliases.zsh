#!/usr/bin/zsh


#
# Define out alias list and optional options
#

typeset -A _DOTZSH_ALIAS_LIST
typeset -A _DOTZSH_ALIAS_OPTS
_DOTZSH_ALIAS_LIST[obes]="172.16.0.210"
_DOTZSH_ALIAS_LIST[sr]="src.run"
_DOTZSH_ALIAS_LIST[rmf-001]="104.154.65.106"
_DOTZSH_ALIAS_LIST[obes-remote]="108.2.193.83"
_DOTZSH_ALIAS_OPTS[obes-remote]="-p 49716"


#
# Define function to setup and assign the aliases via the configured variables
#

function _dotzsh_setup_aliases()
{
  local host
  local name
  local name_full
  local prefix=( "" "srv-" "ssh-" )
  local cmd
  local template="\\n #\\n # [ SSH Alias Configuration Resolver ]\\n #\\n # - NAME: "%s"\\n # - USER: "%s"\\n # - HOST: "%s"\\n # - OPTS: "%s"\\n #\\n # Establishing connection...\\n #\\n\\n ---\\n"

  for k in "${(@k)_DOTZSH_ALIAS_LIST}"; do
    name="${k}"
    host="${_DOTZSH_ALIAS_LIST[$k]}"
    cmd="${USER}@${host}"
    opt=""

    if [[ "${_DOTZSH_ALIAS_OPTS[$name]}" != "" ]]; then
        opt="${_DOTZSH_ALIAS_OPTS[$name]}"
    fi

    for pre in "${prefix[@]}"; do
      which "${cmd}" > /dev/null
      if [[ "$?" -eq "1" ]]; then
        name_full="${pre}${name}"

        if [[ "$opt" == "" ]]; then
          opt_str="null"
        else
          opt_str="$opt"
        fi
        
        alias $name_full="clear ; sleep .33 ; echo '$(printf $template "${name}" "$USER" "${host}" "${opt_str}")' ; echo '' ; ssh $opt $cmd"
        #alias $name_full="${alias_cmd}"
      fi
    done
  done
}


#
# Do it!
#

_dotzsh_setup_aliases


#
# Clean up our left-over vars
#

unset _dotzsh_setup_aliases
unset _DOTZSH_ALIAS_LIST
unset _DOTZSH_ALIAS_OPTS

# EOF

#!/bin/bash

declare INST_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}" 2> /dev/null)" && pwd)"

out_nl()
{
  echo -en "\n"
}

out()
{
  echo -n "${1:-}"
  [ "${2:-false}" == "true" ] && out_nl
}

out_prefix()
{
  [ -z $out_prefix_count ] && count=0
  out_prefix_count=$((($out_prefix_count + 1)))

  bright_out_builder "[$(basename $0):$(printf "%03d" $out_prefix_count)]" \
    "color:black" "color_bg:white" "control:style reverse"
  out " " false
}

out_line()
{
  out_prefix
  bright_out_builder " --- " "color:magenta" "control:style bold"
  out " $1" true
}

out_title()
{
  out_prefix
  bright_out_builder " +++ " "control:style bold" "control:style reverse"
  out " OHMYZSH/DOTZSH INSTALLER"
  out_nl
}

out_error()
{
  out_prefix
  bright_out_builder " !!! " "color_bg:red"
  bright_out_builder " $1" "color:red" "control:style bold"
  out_nl
}

out_instructions()
{
  bright_out_builder "$1" "color:white" "control:style bold"
  out_nl
}

out_state_start()
{
  out_prefix
  bright_out_builder " --- " "color:magenta" "control:style bold"
  out " ${1:-starting operation} ... " false
}

out_state_done_success()
{
  bright_out_builder " ${1:-okay} " "color:white" "color_bg:green" "control:style bold"
  out_nl
}

out_state_done_error()
{
  bright_out_builder " ${1:-fail} " "color:white" "color_bg:red"
  out_nl
}

out_state_done_okay()
{
  bright_out_builder "${1:-done}" "color:green" "control:style bold"
  out_nl
}

out_state_done()
{
  case "$1" in
      0 ) out_state_done_okay ;;
      * ) out_state_done_error ;;
  esac
}

main()
{
	local dot_zsh_path=$INST_PATH/.dot-zsh
  out_title "DOT-ZSH Installer"
  out_line
  out_line "Using path $dot_zsh_path"

  out_state_start "Installing ZSH"
  sudo apt install zsh
  out_state_done $?

	out_state_start "Installing DOT ZSH"
  out_state_done 0

  out_state_start "Installing Oh My ZSH"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  out_state_done $?

  out_state_start "Installing fonts"
	$HOME/.dot-zsh/fonts/install.sh
  out_state_done $?

  out_state_start "Creating RC file"
	rm $HOME/.zshrc
	ln -s $HOME/.dot-zsh/rc.zsh $HOME/.zshrc
  out_state_done $?

  out_instructions
  out_instructions " # Run the following to enable ZSH"
  out_instructions
  out_instructions " chsh -s /bin/zsh"
  out_instructions
}

git clone git@github.com:src-run/dot-zsh.git $HOME/.dot-zsh
git submodule update --init
source $HOME/.dot-zsh/bright/bright.bash

main  


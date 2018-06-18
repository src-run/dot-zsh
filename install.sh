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
    ZSH=~/.oh-my-zsh
    umask g-w,o-w

    local dot_zsh_path=$INST_PATH/.dot-zsh
    out_title "DOT-ZSH Installer"
    out_line
    out_line "Using path $dot_zsh_path"

    out_state_start "Installing deps"
    sudo apt install make bc
    out_state_done $?

    out_state_start "Installing ZSH"
    sudo apt install zsh
    out_state_done $?

    out_state_start "Installing DOT ZSH"
    out_state_done 0

    out_state_start "Installing Oh My ZSH"
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH &> /dev/null
    out_state_done $?

    out_state_start "Installing fonts"
    $HOME/.dot-zsh/fonts/install.sh &> /dev/null
    out_state_done $?

    out_state_start "Installing fonts"
    wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz &> /dev/null
    tar -xzvf chruby-0.3.9.tar.gz &> /dev/null
    cd chruby-0.3.9/ &> /dev/null
    sudo make install
    out_state_done $?

    cd ..

    out_state_start "Installing phpenv"
    git clone https://github.com/src-run/phpenv.git &> /dev/null
    phpenv/bin/phpenv-install.sh
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

git clone https://github.com/src-run/dot-zsh.git $HOME/.dot-zsh
cd $HOME/.dot-zsh && git submodule update --init
source $HOME/.dot-zsh/bright/bright.bash

main

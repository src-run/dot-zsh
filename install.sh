#!/bin/bash

declare INST_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}" 2> /dev/null)" && pwd)"

STATE_DESC=""
STATE_INFO_OUTPUT=0
STATE_INFO_NLS=0

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
    return
    [ -z $out_prefix_count ] && count=0
    out_prefix_count=$((($out_prefix_count + 1)))

    out_custom "[$(basename $0):$(printf "%03d" $out_prefix_count)]" \
        "fg:black bg:white style:reverse"
    out " " false
}

out_line()
{
    out_prefix
    out_custom " ――― " "fg:magenta style:bold"
    out ' ○'
    out " $1" true
}

out_title()
{
    out_prefix
    out_custom " +++ " "style:bold style:reverse"
    out_custom ' ◎ [ src-run/dot-zsh installer ]' 'style:bold'
    out_nl
}

out_complete()
{
    out_prefix
    out_custom " +++ " "style:bold style:reverse"
    out_custom ' ◎ [ completed installation ]' 'style:bold'
    out_nl
}

out_error()
{
    out_prefix
    out_custom " !!! " "bg:red"
    out_custom ' ○' 'fg:light-red'
    out_custom " $1" "fg:red style:bold"
    out_nl
}

out_instructions()
{
    out_custom "$1" "fg:white style:bold"
    out_nl
}

out_state_start()
{
    local desc="${1:-starting operation}"

    STATE_DESC="${desc}"

    out_prefix
    out_custom " ――― " "fg:magenta style:bold"
    out ' ○'
    out " ${desc} … " false
}

out_state_info()
{
    STATE_INFO_OUTPUT=1
    out_custom "(${1,,}) " "fg:white"
}

out_state_status()
{
    out_prefix
    out_custom ' ――― ' 'fg:magenta style:bold'
    out_custom '   ► ' 'fg:white style:dim'
    out_custom "${1} … " 'fg:white'
}

out_state_done_prefix()
{
    if [[ ${STATE_INFO_NLS} -eq 1 ]]; then
        out_nl
        out_state_start "${STATE_DESC}"
    fi

    if [[ ${STATE_INFO_OUTPUT} -eq 1 ]]; then
        out_custom '… ' 'fg:white'
    fi

    STATE_INFO_OUTPUT=0
}

out_state_done_success()
{
    out_custom "${1:-OKAY}" "fg:green style:bold"
    out_nl
}

out_state_done_error()
{
    out_custom "${1:-FAIL}" "fg:red style:bold"
    out_nl
}

out_state_done_okay()
{
    out_custom "${1:-DONE}  " "bg:blue style:bold"
    out_nl
}

out_state_done()
{
    case "$1" in
            0 ) out_state_done_success ;;
            * ) out_state_done_error ;;
    esac
}

out_state_custom()
{
    local desc="${1}"
    local type="${2:-fg:white style:bold}"

    out_custom "${desc}" "${type}"
    out_nl
}

get_os_type()
{
    case "${OSTYPE}" in
        linux* )
            printf 'linux'
            ;;
        darwin* )
            printf 'darwin'
            ;; 
        solaris* )
            printf 'solaris'
            ;;
        bsd* )
            printf 'bsd'
            ;;
        *)
            printf 'unknown'
            ;;
    esac
}

is_os_linux()
{
    [[ $(get_os_type) == 'linux' ]] && echo true || echo false
}

is_os_darwin()
{
    [[ $(get_os_type) == 'darwin' ]] && echo true || echo false
}

resolve_brew_pkg_manager_bin()
{
    which brew 2> /dev/null
}

resolve_apt_get_pkg_manager_bin()
{
    which apt-get 2> /dev/null
}

install_darwin_dependencies()
{
    out_state_start "Installing deps"
    out_nl
    out_state_status 'Detected operating system'
    out_state_custom 'darwin (osx)'

    local brew="$(resolve_brew_pkg_manager_bin)"

    if [[ -z "${brew}" ]]; then
        out_state_done_error
        out_error 'You must install the "brew" package manager before continuing!'
        exit 255
    fi

    out_state_status "Detected package manager"
    out_state_custom "${brew}"

    for p in grep gnu-sed coreutils zsh; do
        out_state_status "Installing \"${p}\" package"
        ${brew} install ${p} --with-default-names &> /dev/null
        out_state_done $?
    done
}

install_linux_dependencies()
{
    out_state_start "Installing deps"
    out_nl
    out_state_status 'Detected operating system'
    out_state_custom 'linux'

    local apt="$(resolve_apt_get_pkg_manager_bin)"

    if [[ -z "${apt}" ]]; then
        out_state_done_error
        out_error 'You must install the "apt" package manager before continuing!'
        exit 255
    fi

    out_state_status "Detected package manager"
    out_state_custom "${apt}"

    for p in make bc zsh; do
        out_state_status "Installing \"${p}\" package"
        sudo ${apt} install ${p} &> /dev/null
        out_state_done $?
    done
}

main()
{
    umask g-w,o-w

    out_title

    out_state_start 'Preparing environment'
    out_nl
 
    out_state_status 'Determined "dot-zsh" install path'
    out_state_custom "$HOME/.dot-zsh"
 
    out_state_status 'Determined "oh-my-zsh" install path'
    out_state_custom "$HOME/.oh-my-zsh"
 
    if [[ -d "$HOME/.dot-zsh" ]]; then
        out_state_status 'Removing previous "dot-zsh" install'
        rm -fr $HOME/.dot-zsh &> /dev/null
        out_state_done $?
    fi

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        out_state_status 'Removing previous "oh-my-zsh" install'
        rm -fr $HOME/.oh-my-zsh &> /dev/null
        out_state_done $?
    fi

    if [[ $(is_os_darwin) == "true" ]]; then
        install_darwin_dependencies
    elif [[ $(is_os_linux) == "true" ]]; then
        install_linux_dependencies
    else
        out_error 'Unsupported OS!'
        exit 255
    fi

    out_state_start "Installing components"
    out_nl
    out_state_status 'Fetching "https://github.com/src-run/dot-zsh.git"'
    git clone https://github.com/src-run/dot-zsh.git $HOME/.dot-zsh &> /dev/null && \
        cd $HOME/.dot-zsh &> /dev/null && \
        git submodule update --init &> /dev/null
    out_state_done $?

    out_state_status 'Fetching "https://github.com/robbyrussell/oh-my-zsh.git"'
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh &> /dev/null && \
        cd $HOME/.dot-zsh &> /dev/null && \
        git submodule update --init &> /dev/null
    out_state_done $?

    #out_state_start "Installing fonts"
    #$HOME/.dot-zsh/fonts/install.sh &> /dev/null
    #out_state_done $?

    #out_state_start "Installing fonts"
    #wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz &> /dev/null
    #tar -xzvf chruby-0.3.9.tar.gz &> /dev/null
    #cd chruby-0.3.9/ &> /dev/null
    #sudo make install
    #out_state_done $?

    #cd ..

    #out_state_start "Installing phpenv"
    #git clone https://github.com/src-run/phpenv.git &> /dev/null
    #phpenv/bin/phpenv-install.sh
    #out_state_done $?

    out_state_start "Configuring components"
    out_nl

    out_state_status "Linking $HOME/.zshrc file"
    rm -f $HOME/.zshrc &> /dev/null && \
        ln -s $HOME/.dot-zsh/rc.zsh $HOME/.zshrc &> /dev/null
    out_state_done $?

    out_complete

    out_instructions
    out_instructions " # Run the following to enable ZSH"
    out_instructions " $ $(which chsh) -s $(which zsh)"
    out_instructions
}


source ${INST_PATH}/bright/bright.bash
BRIGHT_AUTO_NL=0

main

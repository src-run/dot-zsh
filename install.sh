#!/bin/bash


#
# Internal variables.
#

_DZ_INSTALLER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}" 2> /dev/null)" && pwd)"


#
# Output new line.
#

function out_nl {
    echo -en "\n"
}


#
# Output conditional new line.
#

function out_nl_conditional {
    if [[ "${1:-true}" == "true" ]] || [[ ${1:-0} -eq 0 ]]; then
        out_nl
    fi
}


#
# Output text.
#

function out {
    local value="${1:-}"
    local style="${2:-}"

    if [[ -z "${style}" ]]; then
        printf "${value}"
    else
        out_custom "${value}" "${style}"
    fi
}


#
# Output single space padded string.
#

function out_padded {
    out " ${1:-} " "${2:-}"
}


#
# Output line prefix text.
#

function out_prefix {
    out_padded "${1:-―――}" "${2:-fg:magenta style:bold}"
}


#
# Output line prefix text (subs).
#

function out_prefix_subs {
    out_prefix
}


#
# Output line prefix text (bold).
#

function out_prefix_bold {
    out_prefix '+++' 'style:bold style:reverse'
}


#
# Output line prefix text (fail).
#

function out_prefix_fail {
    out_prefix '!!!' 'fg:white bg:red'
}


#
# Output line bullet character.
#

function out_bullet {
    out_padded "${1:-○}" "${2:-}"
}


#
# Output line bullet character (subs).
#

function out_bullet_subs {
    out_bullet_bold '  ►' 'style:dim'
}


#
# Output line bullet character (bold).
#

function out_bullet_bold {
    out_bullet '◎' 'style:bold'
}


#
# Output line bullet character (fail).
#

function out_bullet_fail {
    out_bullet '○' 'fg:light-red'
}


#
# Output ellipsis character.
#

function out_ellipsis {
    out_padded '…'
}


#
# Output styled line string.
#

function out_string {
    out "${1:-}" "${2:-}"
    out_nl_conditional ${3:-true}
}



#
# Output styled line string (subs).
#

function out_string_subs {
    out_string "${1}" 'fg:white' false
    out_ellipsis
    out_nl_conditional ${2:-false}
}


#
# Output styled line string (bold).
#

function out_string_bold {
    out_string "[ ${1} ]" 'style:bold' ${2:-true}
}


#
# Output styled line string (fail).
#

function out_string_fail {
    out_string "${1}" "fg:red style:bold" ${2:-true}
}


#
# Output line of text (optionally styled with optional newline).
#

function out_line {
    local type="${1:-norm}"
    local text="${2:-}"
    local line="${3:-true}"

    case "${type}" in
        subs)
            out_prefix_subs
            ;;
        bold)
            out_prefix_bold
            ;;
        fail)
            out_prefix_fail
            ;;
        *)
            out_prefix
    esac

    if [[ -z "${text}" ]]; then
        out_nl_conditional ${line} && return
    fi

    case "${type}" in
        subs)
            out_bullet_subs
            out_string "${text}" ${line}
            ;;
        bold)
            out_bullet_bold
            out_string "${text}" ${line}
            ;;
        fail)
            out_bullet_fail
            out_string "${text}" ${line}
            ;;
        *)
            out_bullet
            out_string "${text}" ${line}
    esac

}


#
# Output title line of text.
#

function out_title {
    out_line 'bold' 'src-run/dot-zsh installer'
}


#
# Output completion line of text.
#

function out_complete {
    out_line 'bold' 'completed all steps of installer'
}


#
# Output fail line of text.
#

function out_fail {
    out_line 'fail' "${1}"
}


#
# Output inst line of text.
#

function out_inst {
    out_custom "$1" "fg:white style:bold"
    out_nl
}


#
# Start state output.
#

function out_state_start {
    out_prefix
    out_bullet
    out "${1:-starting operation}"
    out_ellipsis
}


#
# Start sub-state output.
#

function out_state_start_subs {
    out_prefix
    out_bullet_subs
    out "${1}" 'fg:white'
    out_ellipsis
}


#
# Close state output as okay.
#

function out_state_close_okay {
    out_string "${1:-OKAY}" "fg:green style:bold"
}


#
# Close state output as fail.
#

function out_state_close_fail {
    out_string "${1:-FAIL}" "fg:red style:bold"
}


#
# Close state output as done.
#

function out_state_close_done {
    out_string "${1:-DONE}  " "bg:blue style:bold"
}


#
# Close state output as cust.
#

function out_state_close_cust {
    local desc="${1}"
    local type="${2:-fg:white style:bold}"

    out_string "${desc}" "${type}"
}


#
# Close state output based on return code.
#

function out_state_close {
    local result="${1:-0}"

    case "${result}" in
            0)
                out_state_close_okay
                ;;
            *)
                out_state_close_fail
                out_fail 'Haling script due to previous error!'
                exit ${result}
                ;;
    esac
}


#
# Determine operating system type.
#

function get_os_type {
    case "${OSTYPE}" in
        linux*)
            printf 'linux'
            ;;
        darwin*)
            printf 'darwin'
            ;;
        solaris*)
            printf 'solaris'
            ;;
        bsd*)
            printf 'bsd'
            ;;
        *)
            printf 'unknown'
            ;;
    esac
}


#
# Checks if operating system is linux.
#

function is_os_linux {
    [[ $(get_os_type) == 'linux' ]] && echo true || echo false
}


#
# Checks if operating system is darwin.
#

function is_os_darwin {
    [[ $(get_os_type) == 'darwin' ]] && echo true || echo false
}


#
# Locates the absolute bin path of brew.
#

function resolve_brew_pkg_manager_bin {
    which brew 2> /dev/null
}


#
# Locates the absolute bin path of apt-get.
#

function resolve_apt_get_pkg_manager_bin {
    which apt-get 2> /dev/null
}


#
# Output dependency installation info.
#

function install_dependencies_info {
    local os="${1}"
    local pkg_manager_name="${2}"
    local pkg_manager_path="${3}"

    out_state_start "Installing dependencies"
    out_nl
    out_state_start_subs 'Detected operating system'
    out_state_close_cust "$(get_os_type)"

    if [[ -z "${pkg_manager_path}" ]] || [[ ! -f "${pkg_manager_path}" ]]; then
        out_state_close_fail
        out_fail \
            "The \"${pkg_manager_name}\" package manager must be installed!"
        exit 255
    fi

    out_state_start_subs "Detected package manager"
    out_state_close_cust "${pkg_manager_path}"
}


#
# Installs dependencies using provided bin, call, and opts.
#

function install_dependencies_acts {
    local pkg_manager_path="${1}"; shift
    local pkg_manager_call="${1}"; shift
    local pkg_manager_opts="${1}"; shift

    for package in "$@"; do
        out_state_start_subs "Installing \"${package}\" package"
        ${pkg_manager_path} ${pkg_manager_call} ${package} ${pkg_manager_opts}
        out_state_close $?
    done

    out_state_start_subs "Completed installation of ${#} packages"
    out_state_close_done
}


#
# Installs dependencies for darwin systems.
#

function install_darwin_dependencies {
    local brew
    local packages="grep gnu-sed coreutils jq zsh"

    brew="$(resolve_brew_pkg_manager_bin)"

    install_dependencies_info 'darwin' 'brew' "${brew}"
    install_dependencies_acts "${brew}" 'install' '--with-default-names' \
        'grep' 'gnu-sed' 'coreutils' 'jq' 'zsh'
}


#
# Installs dependencies for linux systems.
#

function install_linux_dependencies {
    local apt
    local packages="make bc jq zsh"

    apt="$(resolve_apt_get_pkg_manager_bin)"
    export DEBIAN_FRONTEND=noninteractive

    install_dependencies_info 'linux' 'apt-get' "${apt}"
    install_dependencies_acts "${brew}" 'install' '-yq' \
        'make' 'bc' 'jq' 'zsh'
}


#
# The main program function (all the magic starts here).
#

function main {
    # Define out install paths and git remotes
    local _DZ_INSTALL_TO="${HOME}/.dot-zsh"
    local _DZ_GIT_REMOTE="https://github.com/src-run/dot-zsh.git"
    local _OZ_ZSH_INSTALL_TO="${HOME}/.oh-my-zsh"
    local _OZ_ZSH_GIT_REMOTE="https://github.com/robbyrussell/oh-my-zsh.git"

    # Prevent the cloned repository from having insecure permissions. Failing to
    # do so causes failures like "command not found: " for users with insecure
    # umasks (e.g., "002", allowing group writing).
    umask g-w,o-w

    # Write out title
    out_title

    # Start environment state and force newline
    out_state_start 'Preparing environment'
    out_nl

    # Write dot-zsh install path
    out_state_start_subs 'Determined "dot-zsh" install path'
    out_state_close_cust "${_DZ_INSTALL_TO}"

    # Write oh-my-zsh install path
    out_state_start_subs 'Determined "oh-my-zsh" install path'
    out_state_close_cust "${_OZ_ZSH_INSTALL_TO}"

    # Remove previous dot-zsh install if exists
    if [[ -d "${_DZ_INSTALL_TO}" ]]; then
        out_state_start_subs 'Removing previous "dot-zsh" install'
        rm -fr ${_DZ_INSTALL_TO} &> /dev/null
        out_state_close $?
    fi

    # Remove previous oh-my-zsh install if exists
    if [[ -d "${_OZ_ZSH_INSTALL_TO}" ]]; then
        out_state_start_subs 'Removing previous "oh-my-zsh" install'
        rm -fr ${_OZ_ZSH_INSTALL_TO} &> /dev/null
        out_state_close $?
    fi

    # Install dependencies
    if [[ $(is_os_darwin) == "true" ]]; then
        install_darwin_dependencies
    elif [[ $(is_os_linux) == "true" ]]; then
        install_linux_dependencies
    else
        out_fail "Your operating system is unsupported: $(get_os_type)"
        exit 255
    fi

    # Start install components state and force newline
    out_state_start "Installing components"
    out_nl

    # Clone dot-zsh and initialize/update any submodules
    out_state_start_subs "Fetching \"${_DZ_GIT_REMOTE}\""
    git clone ${_DZ_GIT_REMOTE} ${_DZ_INSTALL_TO} &> /dev/null && \
        cd ${_DZ_INSTALL_TO} &> /dev/null && \
        git submodule update --init &> /dev/null
    out_state_close $?

    # Clone oh-my-zsh and initialize/update any submodules
    out_state_start_subs "Fetching \"${_OZ_ZSH_GIT_REMOTE}\""
    git clone --depth=1 \
        ${_OZ_ZSH_GIT_REMOTE} ${_OZ_ZSH_INSTALL_TO} &> /dev/null && \
        cd ${_OZ_ZSH_INSTALL_TO} &> /dev/null && \
        git submodule update --init &> /dev/null
    out_state_close $?

    #out_state_start "Installing fonts"
    #${_DZ_INSTALL_TO}/fonts/install.sh &> /dev/null
    #out_state_close $?

    #out_state_start "Installing fonts"
    #wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz &> /dev/null
    #tar -xzvf chruby-0.3.9.tar.gz &> /dev/null
    #cd chruby-0.3.9/ &> /dev/null
    #sudo make install
    #out_state_close $?

    #cd ..

    #out_state_start "Installing phpenv"
    #git clone https://github.com/src-run/phpenv.git &> /dev/null
    #phpenv/bin/phpenv-install.sh
    #out_state_close $?

    # Start config components state and force newline
    out_state_start "Configuring components"
    out_nl

    # Creating from ~/.zshrc to package rc.zsh file
    out_state_start_subs "Linking $HOME/.zshrc file"
    rm -f $HOME/.zshrc &> /dev/null && \
        ln -s ${_DZ_INSTALL_TO}/rc.zsh $HOME/.zshrc &> /dev/null
    out_state_close $?

    # White script completion notice
    out_complete

    # Write instructions to enable zsh shell by default
    out_inst
    out_inst " # Run the following to enable ZSH"
    out_inst " $ $(which chsh) -s $(which zsh)"
    out_inst
}


#
# Include the bright library to enable colored output
#
source "${_DZ_INSTALLER_PATH}/include.d-libs/bright/bright.bash"


#
# Configure bright library not to auto output new lines.
#

BRIGHT_AUTO_NL=0


#
# Go!
#

main


#
# Cleanup internal variables (unset them).
#

for v in BRIGHT_AUTO_NL DEBIAN_FRONTEND _DZ_GIT_REMOTE _DZ_INSTALLER_PATH _DZ_INSTALL_TO _OZ_ZSH_GIT_REMOTE _OZ_ZSH_INSTALL_TO; do
    eval "unset ${v} 2> /dev/null" 2> /dev/null
done


#
# Cleanup internal functions (unset them).
#

for f in out_nl out_nl_conditional out out_padded out_prefix out_prefix_subs out_prefix_bold out_prefix_fail out_bullet out_bullet_subs out_bullet_bold out_bullet_fail out_ellipsis out_string out_string_subs out_string_bold out_string_fail out_line out_title out_complete out_fail out_inst out_state_start out_state_start_subs out_state_close_okay out_state_close_fail out_state_close_done out_state_close_cust out_state_close get_os_type is_os_linux is_os_darwin resolve_brew_pkg_manager_bin resolve_apt_get_pkg_manager_bin install_dependencies_info install_dependencies_acts install_darwin_dependencies install_linux_dependencies main; do
    eval "unset -f ${f} 2> /dev/null" 2> /dev/null
done

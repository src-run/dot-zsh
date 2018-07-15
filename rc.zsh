# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="false"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="false"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git, git-extras, gitignore, gnu-utils, golang, grunt, gulp, bower, bundler, ruby, chruby, colored-man-pages, colorize, command-not-found, copyfile, codeclimate, composer, cp, ubuntu, kitchen, knife, npm, rake, redis-cli, rsync, screen, sublime, sudo, symfony2, vagrant, zsh-syntax-highlighting, history-substring-search)

plugins=(git, git-extras, gitignore, github, sudo, colored-man-pages, colorize, composer, bower, command-not-found, composer, docker, ruby, gem, chruby, gulp, grunt, node, npm, rake, rsync, screen, sublime, symfony, systemd)
#, git-extras, gitignore, gulp, grunt, ruby, bundler, bower, web-search, colored-man-pages, colorize, copyfile, composer, cp, ubuntu, npm, symfony2, sudo, screen, command-not-found, history-substring-search, zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

[ -f $HOME/.dot-zsh/load.zsh ] && source $HOME/.dot-zsh/load.zsh
stty -ixon

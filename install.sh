#!/bin/bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git@github.com:src-run/dot-zsh.git $HOME/.dot-zsh
git clone https://github.com/powerline/fonts.git $HOME/.dot-zsh/fonts
rm $HOME/.zshrc
ln -s $HOME/.dot-zsh/rc.zsh $HOME/.zshrc

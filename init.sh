#!/bin/sh 

brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font
brew install tree-sitter
brew install clipboard
brew install ripgrep
brew install lazygit
brew install -f gdu
brew install bottom
brew install watch fswatch

cd lua/plugins/conf
git clone git@github.com:oat-sa/prettier-config.git
git clone git@github.com:oat-sa/eslint-config-tao.git

sudo ln -s $(which wslview) /usr/local/bin/xdg-open

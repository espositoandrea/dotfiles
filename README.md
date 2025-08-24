# Dotfiles

This repository holds all of my dotfiles.
For future reference, this repository was set up using a
[git "bare repository"](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

## How to Restore?

To restore this configuration, after ensuring that `git` is installed, run the following:

```sh
echo ".cfg" >> .gitignore
git clone --bare git@github.com:espositoandrea/dotfiles.git $HOME.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```

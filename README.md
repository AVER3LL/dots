<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [My dotfiles](#my-dotfiles)
  - [Requirements](#requirements)
    - [Git](#git)
    - [Stow](#stow)
  - [Installation](#installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# My dotfiles

This directory contains my personal dotfiles.

## Requirements

Ensure you have the following installed on your system

### Git

```sh
sudo pacman -S git
```

### Stow

```sh
sudo pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```sh
git clone git@gitlab.com:leonel.tchassou/dotfiles.git $HOME/dotfiles
cd dotfiles
```

then use GNU stow to create the symlinks

```sh
stow .
```

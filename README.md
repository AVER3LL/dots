# My Dotfiles

This repository contains my personal dotfiles for various applications including Neovim, Hyprland, Waybar, Swaync, Swayosd, and Fabric.

## Screenshots

![Screenshot 1](.art/1.png)

<details><summary>View Other screenshots</summary>

![Screenshot 2](.art/2.png)
![Screenshot 3](.art/3.png)
![Screenshot 5](.art/5.png)
![Fabric Screenshot](.art/fabric.png)
![Old Screenshot](.art/old.png)

</details>

## Applications Configured

- **Neovim**: Custom configuration in `.config/nvim/`
- **Hyprland**: Window manager setup in `.config/hypr/`
- **Waybar**: Status bar configuration in `.config/waybar/`
- **Swaync**: Notification center in `.config/swaync/`
- **Swayosd**: On-screen display in `.config/swayosd/`
- **Fabric**: Additional configurations in `.config/fabric/`

## Installation with Stow

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles by creating symlinks.

To install all dotfiles:

```bash
git clone https://github.com/AVER3LL/dots.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

To install specific configurations:

```bash
stow ./.config/nvim
stow ./.config/hypr
stow ./.config/waybar
stow ./.config/swaync
stow ./.config/swayosd
stow ./.config/fabric
```

To remove symlinks:

```bash
stow -D nvim
```

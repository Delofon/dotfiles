# Dotfiles!

## Deployment

1. Install `i3`, `tmux`, `vim` and etc. with your package manager.
2. Execute `install-pms.sh`
3. Execute `install.sh`
4. Press `C-Space Shift-i` in `tmux` to install `tpm` plugins
5. Run `:PlugInstall` in `vim` to install `vim-plug` plugins

## Modification

The `dotfiles` (root of the repo) directory mirrors the way how the dotfiles are going to be located in the home directory.
The `manifest` file is a configuration file of sorts for `install.sh` and contains relative paths to files that are symlinked by `install.sh`.

For example, consider the dotfile `~/.config/i3/config`.
To manage this dotfile, you need to move it to `dotfiles/.config/i3/config`, then add `.config/i3/config` line to `manifest`.
`install.sh` will then symlink this dotfile's location in home to it: `~/.config/i3/config` --> `dotfiles/.config/i3/config`


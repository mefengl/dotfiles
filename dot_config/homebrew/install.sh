NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew cleanup

packages=(
    starship
    autojump
    trash
    tldr
    chezmoi
    neovim
    tmux

    pyenv
    aria2 # for quicker xcodes download
    robotsandpencils/made/xcodes

    bitwarden-cli

    gh
)

for package in "${packages[@]}"; do
    brew install "$package"
done

casks=(
    homebrew/cask-fonts/font-fira-code-nerd-font

    visual-studio-code
    iterm2
    openinterminal

    bob
    calibre
    mark-text
    wechat
)

for cask in "${casks[@]}"; do
    brew install --cask "$cask"
done

# python
pyenv install 3.10
pyenv global 3.10
pip install --upgrade pip
pip install asitop

# xcodes
xcodes install --latest --experimental-unxip

#0.5 Else
# git yabai skhd
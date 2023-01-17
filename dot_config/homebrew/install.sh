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

    bitwarden-cli
)

for package in "${packages[@]}"; do
    brew install "$package"
done

# pyenv
pyenv install 3.10
pyenv global 3.10

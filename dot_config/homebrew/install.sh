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

#0.5 Else
# ❯ brew list
# ==> Formulae
# ack                     clisp                   gmp                     libde265                libtool                 msgpack                 python@3.10             thrift
# aom                     docbook                 gnu-getopt              libevent                libunistring            ncurses                 python@3.11             tldr
# autoconf                docbook-xsl             gnu-sed                 libheif                 libusb                  neovim                  python@3.8              tmux
# autojump                docutils                gnutls                  libidn                  libuv                   nettle                  pyyaml                  trash
# automake                figlet                  guile                   libidn2                 libvmaf                 node                    qemu                    tree
# aws-sam-cli             fontconfig              highway                 liblqr                  libvterm                nvm                     rain                    tree-sitter
# bat                     freetype                httpie                  libnghttp2              libyaml                 oniguruma               rbenv                   unbound
# bdw-gc                  fzy                     icu4c                   libomp                  libzip                  openexr                 readline                unibilium
# berkeley-db             gdbm                    im-select               libpng                  little-cms2             openjpeg                ruby-build              utf8proc
# bitwarden-cli           gettext                 imath                   libraw                  lolcat                  openssl@1.1             shared-mime-info        vde
# brotli                  gh                      jansson                 libsigsegv              luajit                  p11-kit                 six                     webp
# c-ares                  ghostscript             jasper                  libslirp                luv                     pcre2                   skhd                    x265
# ca-certificates         giflib                  jbig2dec                libssh                  lz4                     pixman                  snappy                  xmlto
# capstone                git                     jpeg-turbo              libtasn1                lzo                     pkg-config              sqlite                  xz
# catimg                  gitmoji                 jpeg-xl                 libtermkey              m4                      podman                  starship                yabai
# chezmoi                 glib                    jq                      libtiff                 mpdecimal               pyenv                   tcl-tk                  zstd

# ==> Casks
# bob                             font-fira-code-nerd-font        highflux                        iterm2                          openinterminal                  wine-stable
# font-dejavu-sans-mono-nerd-font hammerspoon                     httpie                          mark-text                       visual-studio-code

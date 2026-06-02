#!/bin/bash
# SPDX-FileCopyrightText: Timothée Ravier <tim@siosm.fr>
# SPDX-License-Identifier: CC0-1.0

set -euxo pipefail

# Prepare for stuff that installs to /opt
mkdir -p /var/opt
ln -sf /var/opt /opt

# use negativo17 for 3rd party packages with higher priority than default
if ! grep -q fedora-multimedia <(dnf5 repolist); then
    # Enable or Install Repofile
    dnf5 config-manager setopt fedora-multimedia.enabled=1 ||
        dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
fi
# Set higher priority
dnf5 config-manager setopt fedora-multimedia.priority=90

# use override to replace mesa and others with less crippled versions
OVERRIDES=(
    libheif
    libva
    mesa-dri-drivers
    mesa-filesystem
    mesa-libEGL
    mesa-libGL
    mesa-libgbm
    mesa-va-drivers
    mesa-vulkan-drivers
)

dnf5 distro-sync --skip-unavailable -y --repo='fedora-multimedia' "${OVERRIDES[@]}"
dnf swap -y ffmpeg-free ffmpeg --repo='fedora-multimedia' --allowerasing
dnf5 versionlock add "${OVERRIDES[@]}" ffmpeg

# Uninstall cruft
REMOVE_PACKAGES=(
    fedora-bookmarks
    fedora-chromium-config
    fedora-chromium-config-gnome
    firefox
    firefox-langpacks
    fedora-third-party
    totem-video-thumbnailer
    gnome-classic-session
    gnome-extensions-app
    gnome-shell-extension-apps-menu
    gnome-shell-extension-background-logo
    gnome-shell-extension-launch-new-instance
    gnome-shell-extension-places-menu
    gnome-shell-extension-window-list
    gnome-software
    gnome-terminal-nautilus
    gnome-tour
    yelp
    fedora-flathub-remote
    default-fonts-other-*
    default-fonts-am
    default-fonts-ar
    default-fonts-as
    default-fonts-ast
    default-fonts-be
    default-fonts-bg
    default-fonts-bn
    default-fonts-bo
    default-fonts-br
    default-fonts-chr
    default-fonts-cjk-*
    default-fonts-dv
    default-fonts-dz
    default-fonts-el
    default-fonts-eo
    default-fonts-eu
    default-fonts-fa
    default-fonts-got
    default-fonts-gu
    default-fonts-he
    default-fonts-hi
    default-fonts-hy
    default-fonts-ia
    default-fonts-ii
    default-fonts-iu
    default-fonts-ka
    default-fonts-kab
    default-fonts-km
    default-fonts-kn
    default-fonts-ku
    default-fonts-lo
    default-fonts-mai
    default-fonts-ml
    default-fonts-mni
    default-fonts-mr
    default-fonts-my
    default-fonts-nb
    default-fonts-ne
    default-fonts-nn
    default-fonts-nqo
    default-fonts-nr
    default-fonts-nso
    default-fonts-or
    default-fonts-other-mono
    default-fonts-other-sans
    default-fonts-other-serif
    default-fonts-pa
    default-fonts-ru
    default-fonts-sat
    default-fonts-si
    default-fonts-ss
    default-fonts-syr
    default-fonts-ta
    default-fonts-te
    default-fonts-th
    default-fonts-tn
    default-fonts-ts
    default-fonts-uk
    default-fonts-ur
    default-fonts-ve
    default-fonts-vi
    default-fonts-xh
    default-fonts-yi
    default-fonts-zu
    gdouros-symbola-fonts
    google-noto-naskh-arabic-vf-fonts
    google-noto-sans-arabic-vf
    google-noto-sans-armenian-vf-fonts
    google-noto-sans-bengali-vf-fonts
    google-noto-sans-canadian-aboriginal-vf-fonts
    google-noto-sans-cherokee-vf-fonts
    google-noto-sans-devanagari-vf-fonts
    google-noto-sans-ethiopic-vf-fonts
    google-noto-sans-georgian-vf-fonts
    google-noto-sans-gothic-fonts
    google-noto-sans-gujarati-vf-fonts
    google-noto-sans-gurmukhi-vf-fonts
    google-noto-sans-hebrew-vf-fonts
    google-noto-sans-kannada-vf-fonts
    google-noto-sans-khmer-vf-fonts
    google-noto-sans-lao-vf-fonts
    google-noto-sans-meetei-mayek-vf-fonts
    google-noto-sans-nko-fonts
    google-noto-sans-ol-chiki-vf-fonts
    google-noto-sans-oriya-vf-fonts
    google-noto-sans-sinhala-vf-fonts
    google-noto-sans-syriac-vf-fonts
    google-noto-sans-tamil-vf-fonts
    google-noto-sans-telugu-vf-fonts
    google-noto-sans-thaana-vf-fonts
    google-noto-sans-thai-vf-fonts
    google-noto-sans-yi-fonts
    google-noto-serif-armenian-vf-fonts
    google-noto-serif-bengali-vf-fonts
    google-noto-serif-devanagari-vf-fonts
    google-noto-serif-ethiopic-vf-fonts
    google-noto-serif-georgian-vf-fonts
    google-noto-serif-gujarati-vf-fonts
    google-noto-serif-gurmukhi-vf-fonts
    google-noto-serif-hebrew-vf-fonts
    google-noto-serif-kannada-vf-fonts
    google-noto-serif-khmer-vf-fonts
    google-noto-serif-lao-vf-fonts
    google-noto-serif-oriya-vf-fonts
    google-noto-serif-sinhala-vf-fonts
    google-noto-serif-tamil-vf-fonts
    google-noto-serif-telugu-vf-fonts
    google-noto-serif-thai-vf-fonts
    intel-*
    liberation-*-fonts
    virtualbox-guest-additions
    hyperv*
    qemu-guest-agent
    redhat-menus
)
dnf remove -y "${REMOVE_PACKAGES[@]}"

PACKAGES=(
    pam-u2f
    pamu2fcfg
    adw-gtk3-theme
    niri
    mise
    ghostty
    ghostty-shell-integration
    ghostty-terminfo
    faugus-launcher
    noctalia-shell
    wlsunset
    fish
    steam
    heroic-games-launcher
    cava
    vicinae
    zed
    micro
    rsms-inter-fonts
    https://proton.me/download/PassDesktop/linux/x64/ProtonPass.rpm
    https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm
    tailscale
    vkbasalt
    goverlay
    libvirt
    winpodx
    podman-compose
    podman-docker
    vesktop
    https://megapahit.net/downloads/megapahit-26.2.0.55409-Fedora-x86_64.rpm
    https://app.warp.dev/download?package=rpm
    hyfetch
)

dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf config-manager addrepo -y --from-repofile=https://download.opensuse.org/repositories/home:/Kernalix7/Fedora_43/home:Kernalix7.repo
dnf copr -y enable yalter/niri
dnf copr -y enable jdxcode/mise
dnf copr -y enable scottames/ghostty
dnf copr -y enable quadratech188/vicinae
dnf copr -y enable faugus/faugus-launcher
dnf install -y --setopt=install_weak_deps=False "${PACKAGES[@]}"
dnf copr -y disable yalter/niri
dnf copr -y disable jdxcode/mise
dnf copr -y disable scottames/ghostty
dnf copr -y disable quadratech188/vicinae
dnf copr -y disable faugus/faugus-launcher

# Move opt stuff
mkdir -p /usr/share/factory/var
mv /var/opt /usr/share/factory/var/opt
cat > "/usr/lib/tmpfiles.d/opt.conf" << 'EOF'
C+    /var/opt        -    -    -    -
EOF


# Install Pangolin CLI
curl -o /tmp/pangolin-cli.sh -fsSL https://static.pangolin.net/get-cli.sh
bash -c '. /tmp/pangolin-cli.sh --path /usr/bin'

# Install Proton Pass CLI
export PROTON_PASS_CLI_INSTALL_DIR=/usr/bin
curl -fsSL https://proton.me/download/pass-cli/install.sh | bash

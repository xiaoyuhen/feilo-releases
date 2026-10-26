#!/usr/bin/env bash
# Install or update Feilo, the macOS menu bar text polisher.
#
#   curl -fsSL https://raw.githubusercontent.com/xiaoyuhen/feilo-releases/main/install.sh | bash
#
# Downloads the latest release from github.com/xiaoyuhen/feilo-releases,
# verifies its SHA-256 checksum and that Feilo's certificate signed it, installs Feilo.app into
# /Applications (or ~/Applications when /Applications is not writable),
# clears the quarantine flag (Feilo is not notarized), and opens it.
set -euo pipefail

REPO="xiaoyuhen/feilo-releases"
say() { printf '\033[1m==>\033[0m %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || die "Feilo runs on macOS only."
major="$(sw_vers -productVersion | cut -d. -f1)"
(( major >= 14 )) || die "Feilo needs macOS 14 (Sonoma) or later."

say "Finding the latest release"
api="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest")" \
    || die "could not reach GitHub"
tag="$(printf '%s' "$api" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
[[ -n "$tag" ]] || die "no release found"
version="${tag#v}"
zip="Feilo-$version.zip"
base="https://github.com/$REPO/releases/download/$tag"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
say "Downloading Feilo $version"
curl -fsSL -o "$work/$zip" "$base/$zip"
curl -fsSL -o "$work/$zip.sha256" "$base/$zip.sha256"
(cd "$work" && shasum -a 256 -c "$zip.sha256" >/dev/null) || die "checksum mismatch; not installing"

ditto -x -k "$work/$zip" "$work/unpacked"
app="$work/unpacked/Feilo.app"
# A valid signature alone proves nothing: anyone can sign an app. Feilo's own
# certificate must have signed it, the same check the in-app updater makes.
# scripts/release.sh refuses to publish a build that does not satisfy this.
REQUIREMENT='identifier "io.github.xiaoyuhen.feilo" and certificate root = H"e6099c8a92e88f16d58fffb8ac31a2afeee881bb"'
codesign --verify --deep --strict -R="$REQUIREMENT" "$app" 2>/dev/null \
    || die "the app is not signed with Feilo's certificate; not installing"

target="/Applications"
[[ -w "$target" ]] || { target="$HOME/Applications"; mkdir -p "$target"; }

if pgrep -x Feilo >/dev/null; then
    say "Quitting the running copy"
    osascript -e 'quit app "Feilo"' 2>/dev/null || pkill -x Feilo || true
    sleep 1
fi
say "Installing into $target"
rm -rf "$target/Feilo.app"
ditto "$app" "$target/Feilo.app"
xattr -dr com.apple.quarantine "$target/Feilo.app" 2>/dev/null || true

open "$target/Feilo.app"
say "Feilo $version is installed. Look for its icon in the menu bar."
echo "    On first launch, allow Accessibility access when macOS asks — Feilo"
echo "    needs it to read and replace the text you select."

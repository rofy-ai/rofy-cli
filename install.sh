#!/bin/sh
# Rofy CLI installer for macOS and Linux, for people without Node.
#
#   curl -fsSL https://raw.githubusercontent.com/rofy-ai/rofy-cli/main/install.sh | sh
#   curl -fsSL ... | sh -s -- --prefix "$HOME/.local"
#   curl -fsSL ... | sh -s -- --tag v1.2.3
#
# Windows: npm i -g @rofy/cli
set -e

REPO="rofy-ai/rofy-cli"
PREFIX="/usr/local"
TAG=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefix=*) PREFIX="${1#*=}"; shift ;;
    --prefix)   PREFIX="$2"; shift 2 ;;
    --tag=*)    TAG="${1#*=}"; shift ;;
    --tag)      TAG="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  darwin|linux) ;;
  *) echo "Unsupported system: $OS. On Windows use: npm i -g @rofy/cli" >&2; exit 1 ;;
esac
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported chip: $ARCH" >&2; exit 1 ;;
esac

if [ -z "$TAG" ]; then
  TAG="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n 1)"
  [ -n "$TAG" ] || { echo "Could not find the latest release." >&2; exit 1; }
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
NAME="rofy_${OS}_${ARCH}.gz"
BASE="https://github.com/$REPO/releases/download/$TAG"
echo "Downloading $BASE/$NAME"
curl -fsSL -o "$TMP/$NAME" "$BASE/$NAME"
curl -fsSL -o "$TMP/checksums.json" "$BASE/checksums.json"

# Refuse a download that is not the file the release lists.
WANT="$(sed -n "s/.*\"$NAME\": *\"\([0-9a-f]*\)\".*/\1/p" "$TMP/checksums.json")"
if command -v sha256sum >/dev/null 2>&1; then
  GOT="$(sha256sum "$TMP/$NAME" | cut -d ' ' -f 1)"
else
  GOT="$(shasum -a 256 "$TMP/$NAME" | cut -d ' ' -f 1)"
fi
if [ -z "$WANT" ] || [ "$WANT" != "$GOT" ]; then
  echo "The download's fingerprint does not match. Refusing to install." >&2
  exit 1
fi

gunzip "$TMP/$NAME"
BIN_DIR="$PREFIX/bin"
run() { if [ -w "$BIN_DIR" ] || [ -w "$(dirname "$BIN_DIR")" ]; then "$@"; else sudo "$@"; fi; }
run mkdir -p "$BIN_DIR"
run install -m 0755 "$TMP/rofy_${OS}_${ARCH}" "$BIN_DIR/rofy"
[ "$OS" = "darwin" ] && run xattr -d com.apple.quarantine "$BIN_DIR/rofy" 2>/dev/null || true

echo "Installed: $("$BIN_DIR/rofy" version)"
echo "Next: rofy auth login"

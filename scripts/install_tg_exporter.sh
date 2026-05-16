#!/usr/bin/env bash
# Установка / обновление tg-exporter из GitHub Releases.
# Скачивает последний релиз под текущую OS/arch в ~/.local/bin.
set -euo pipefail

REPO="MrDerunov/telegram-exporter"
INSTALL_DIR="${TG_EXPORTER_INSTALL_DIR:-$HOME/.local/bin}"
BIN="$INSTALL_DIR/tg-exporter"

# --- Определение платформы ---
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)
    case "$ARCH" in
      x86_64)   SUFFIX="linux-x86_64" ;;
      aarch64|arm64) SUFFIX="linux-arm64" ;;
      *) echo "❌ Неподдерживаемая архитектура Linux: $ARCH" >&2; exit 1 ;;
    esac
    ARCHIVE_EXT="tar.gz"
    EXTRACT_CMD="tar xzf"
    ;;
  Darwin)
    case "$ARCH" in
      arm64|aarch64) SUFFIX="mac-arm64" ;;
      x86_64)        SUFFIX="mac-x86_64" ;;
      *) echo "❌ Неподдерживаемая архитектура macOS: $ARCH" >&2; exit 1 ;;
    esac
    ARCHIVE_EXT="tar.gz"
    EXTRACT_CMD="tar xzf"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    SUFFIX="windows-x86_64"
    ARCHIVE_EXT="zip"
    EXTRACT_CMD="unzip -o"
    BIN="$INSTALL_DIR/tg-exporter.exe"
    ;;
  *)
    echo "❌ Неподдерживаемая ОС: $OS" >&2; exit 1 ;;
esac

# --- Получение последней версии ---
echo "📦 Определение последней версии..."
LATEST_TAG=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | head -1 | sed 's/.*"tag_name": "\(.*\)".*/\1/')
if [ -z "$LATEST_TAG" ]; then
  echo "❌ Не удалось определить последнюю версию" >&2
  exit 1
fi
echo "   Версия: $LATEST_TAG"

# --- Скачивание ---
ARCHIVE_NAME="tg-exporter-${SUFFIX}.${ARCHIVE_EXT}"
DOWNLOAD_URL="https://github.com/$REPO/releases/download/${LATEST_TAG}/${ARCHIVE_NAME}"
TMP_DIR=$(mktemp -d)
ARCHIVE_PATH="$TMP_DIR/$ARCHIVE_NAME"

echo "⬇️  Скачивание $DOWNLOAD_URL ..."
curl -sL "$DOWNLOAD_URL" -o "$ARCHIVE_PATH" || {
  echo "❌ Ошибка скачивания" >&2
  rm -rf "$TMP_DIR"
  exit 1
}

# --- Распаковка ---
echo "📂 Распаковка..."
mkdir -p "$INSTALL_DIR"
cd "$TMP_DIR"
$EXTRACT_CMD "$ARCHIVE_PATH"

# Ищем бинарник (может быть tg-exporter или tg-exporter.exe)
if [ -f "tg-exporter" ]; then
  EXE="tg-exporter"
elif [ -f "tg-exporter.exe" ]; then
  EXE="tg-exporter.exe"
else
  echo "❌ Бинарник не найден в архиве" >&2
  ls -la "$TMP_DIR"
  rm -rf "$TMP_DIR"
  exit 1
fi

chmod +x "$EXE"
mv -f "$EXE" "$BIN"
rm -rf "$TMP_DIR"

echo "✅ tg-exporter $LATEST_TAG установлен в $BIN"

# --- Проверка ---
if [ -x "$BIN" ]; then
  echo "   Проверка: $($BIN version 2>/dev/null || echo 'OK (version не поддерживается)')"
else
  echo "⚠️  Бинарник установлен но не исполняемый"
fi

# --- PATH ---
if ! echo "$PATH" | tr ':' '\n' | grep -qF "$INSTALL_DIR"; then
  echo ""
  echo "⚠️  $INSTALL_DIR не в PATH."
  echo "   Добавьте в ~/.bashrc или ~/.zshrc:"
  echo "   export PATH=\"$INSTALL_DIR:\$PATH\""
fi

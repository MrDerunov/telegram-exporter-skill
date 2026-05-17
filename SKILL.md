---
name: telegram-exporter
description: >-
  Export Telegram channel/chat messages to JSON and Markdown using the Telegram Exporter desktop app.
  Use when the user asks to export Telegram data, backup chats, download Telegram messages, extract chat history,
  save Telegram media, collect analytics from Telegram channels, or transcribe voice messages.
  Also use when the user mentions "telegram exporter", "export chat", "backup telegram", "download from telegram",
  "save messages", "archive channel", or "tg-exporter".
metadata:
  openclaw:
    emoji: "📦"
    requires:
      bins: []
    install:
      - id: download
        kind: manual
        label: Download from https://github.com/MrDerunov/telegram-exporter/releases
---

# Telegram Exporter Skill

Десктопное приложение для экспорта чатов и каналов Telegram в JSON и Markdown.
С транскрипцией голосовых, скачиванием медиа и поддержкой нескольких аккаунтов.

## Быстрый старт

1. Скачать бинарник под свою ОС с [GitHub Releases](https://github.com/MrDerunov/telegram-exporter/releases)
2. Запустить приложение
3. Ввести API ID и API Hash (получить на [my.telegram.org](https://my.telegram.org) → API development tools)
4. Войти в аккаунт Telegram (номер → код → 2FA если есть)
5. Выбрать чат, настроить параметры экспорта, нажать «Экспорт»

## Установка

### Готовые сборки

Скачай с [Releases](https://github.com/MrDerunov/telegram-exporter/releases) файл под свою ОС:

| Платформа | Файл |
|-----------|------|
| **macOS Apple Silicon (M1/M2/M3/M4)** | `TelegramExporter-mac-arm64.dmg` |
| **macOS Intel** | `TelegramExporter-mac-intel.dmg` |
| **Windows** | `TelegramExporterSetup.exe` |
| **Linux (x86_64)** | `TelegramExporter-linux-x86_64.tar.gz` |

- **macOS**: открыть DMG, перетащить приложение в Applications
- **Windows**: запустить установщик
- **Linux**: распаковать архив и запустить бинарник внутри

### Из исходников

```bash
git clone https://github.com/MrDerunov/telegram-exporter.git
cd telegram-exporter
python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

Требуется Python 3.11+.

## Первый запуск

1. Получить `api_id` и `api_hash` на [my.telegram.org](https://my.telegram.org) → API development tools
2. Ввести их в окне логина приложения
3. Ввести номер телефона → код из Telegram → (если есть) пароль 2FA
4. После входа можно добавить ещё аккаунты через кнопку **«Аккаунт ▾»** в шапке

> **Если из РФ и не приходит код / «Ошибка соединения»** — включи VPN. Приложение ходит напрямую к серверам Telegram, их IP в России заблокированы. Нужен VPN с полным туннелированием трафика (AmneziaVPN, Outline, WireGuard).

## Возможности

- **Экспорт в JSON или Markdown** — вся история сообщений с метаданными или в удобном для чтения виде (подходит для Obsidian)
- **Несколько аккаунтов** — добавил все свои номера один раз, переключаешься между ними в один клик
- **Транскрипция голосовых и видео-кружков**:
  - Локально через Faster-Whisper (модели от tiny до large-v3)
  - Облачно через Deepgram (nova-3, быстро и точно)
- **Скачивание медиа** — фото, видео, голосовые, документы раскладываются по папкам
- **Фильтры**: период (неделя / месяц / свой диапазон), папки Telegram, авторы
- **Инкрементальный экспорт** — дозабирает только новые сообщения с прошлого раза
- **Аналитика**: топ авторов и активность по датам
- **Безопасность**: `api_hash` и сессии хранятся в системном Keyring, не в открытых файлах
- **Ссылки сохраняются** в JSON и Markdown экспорте

## Интерфейс

Приложение состоит из нескольких экранов:

1. **Окно логина** — ввод API ID/Hash и вход в аккаунт
2. **Список чатов** — поиск, фильтрация по папкам Telegram, выбор чата для экспорта
3. **Настройки экспорта** — формат (JSON/Markdown), период, фильтры, медиа, транскрипция
4. **Прогресс-бар** — отображает ход экспорта с возможностью отмены

## Транскрипция

- **Локальная (Whisper)** — работает офлайн, первый запуск модели скачает её с HuggingFace (от ~75 МБ для `tiny` до ~3 ГБ для `large-v3`). Для `large-v3` желательно 8 ГБ RAM
- **Deepgram** — нужен API-ключ ([deepgram.com](https://deepgram.com)), ключ вводится в настройках приложения и хранится в Keyring

Ограничение: одно голосовое/кружок не длиннее 15 минут.

## Где приложение хранит файлы

```
~/.tg_exporter/
├── config.json              # api_id и настройки (без секретов)
├── profiles.json            # список аккаунтов (без сессий)
├── export_history.json      # для инкрементального экспорта
└── app.log                  # лог приложения
```

Секреты (`api_hash`, сессии, Deepgram key) — в системном Keyring (`tg_exporter`).

## Структура экспорта

После экспорта в выбранной директории создаётся:

```
<output>/
├── result.json              # Полный JSON со всеми сообщениями
├── _part_1.md               # Markdown, часть 1
├── _part_2.md               # Markdown, часть 2 (если >лимита слов)
├── media/
│   ├── photos/              # Фото (.jpg, .png)
│   ├── videos/              # Видео и кружки (.mp4)
│   ├── voices/              # Голосовые (.ogg)
│   ├── documents/           # Документы
│   └── stickers/            # Стикеры (.webp)
├── top_authors.md           # Аналитика: топ авторов (опционально)
├── activity.md              # Аналитика: активность по датам (опционально)
└── export_history.json      # Для инкрементального экспорта
```

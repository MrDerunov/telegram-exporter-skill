---
name: telegram-exporter
description: >-
  Export Telegram channel/chat messages to JSON and Markdown using the tg-exporter CLI.
  Use when the user asks to export Telegram data, backup chats, download Telegram messages, extract chat history,
  save Telegram media, transcribe voice messages, or collect analytics from Telegram channels.
  Also use when the user mentions "telegram exporter", "export chat", "backup telegram", "download from telegram",
  "save messages", "archive channel", or "tg-exporter".
metadata:
  openclaw:
    emoji: "📦"
    requires:
      bins: ["tg-exporter"]
    install:
      - id: script
        kind: script
        script: scripts/install_tg_exporter.sh
        label: Install tg-exporter (GitHub Releases)
      - id: manual
        kind: manual
        label: Download from https://github.com/MrDerunov/telegram-exporter/releases
---

# Telegram Exporter Skill

Экспорт чатов и каналов Telegram в JSON и Markdown через CLI-утилиту `tg-exporter`.

## First-Run Check

При первом использовании проверить готовность окружения:

```bash
# 1. Установлена ли утилита?
which tg-exporter || bash scripts/install_tg_exporter.sh

# 2. Пройти диагностику
tg-exporter doctor
```

Если `doctor` показывает проблемы — сообщить пользователю что нужно исправить.

**Критичные проверки:**
- `tg-exporter` доступен в PATH
- Сессия валидна (`tg-exporter auth status`)
- Есть свободное место на диске
- (опционально) `ffmpeg` для транскрипции

## Если утилита не установлена

```bash
bash scripts/install_tg_exporter.sh
```

Скачивает последнюю версию из GitHub Releases для текущей OS/arch в `~/.local/bin`.

Или вручную:
1. Открыть https://github.com/MrDerunov/telegram-exporter/releases
2. Скачать архив под свою платформу
3. Распаковать, переместить `tg-exporter` в `~/.local/bin`

## Если не авторизован

```bash
tg-exporter auth login
```

Интерактивно запрашивает API ID, API Hash, номер телефона, код из Telegram.
Подробнее: [references/auth_guide.md](references/auth_guide.md).

## Экспорт

### Быстрый старт

```bash
# Экспорт канала по username
tg-exporter export run --chat @channel_name

# Экспорт по ID
tg-exporter export run --chat -1001234567890

# Последние 100 сообщений (быстрый тест)
tg-exporter export run --chat @channel_name --last 100

# Последние 7 дней с медиа
tg-exporter export run --chat @channel_name --days 7 --download-media
```

### Частые сценарии

| Задача | Команда |
|--------|---------|
| Полный экспорт | `tg-exporter export run --chat @name` |
| Только JSON | `tg-exporter export run --chat @name --format json` |
| Только Markdown | `tg-exporter export run --chat @name --format markdown` |
| С медиа | `tg-exporter export run --chat @name --download-media` |
| С транскрипцией | `tg-exporter export run --chat @name --download-media --transcribe` |
| С аналитикой | `tg-exporter export run --chat @name --analytics` |
| Период | `tg-exporter export run --chat @name --days 30` |
| Диапазон дат | `tg-exporter export run --chat @name --date-from 2024-01-01 --date-to 2024-06-01` |
| Последние N | `tg-exporter export run --chat @name --last 500` |
| Продолжить | `tg-exporter export run --chat @name --resume` |
| Все чаты из конфига | `tg-exporter export run --all --skip-unavailable` |

Полный справочник команд: [references/commands.md](references/commands.md).
Детальные сценарии и структура вывода: [references/export_workflows.md](references/export_workflows.md).

## Поиск чатов

```bash
# Список всех чатов
tg-exporter chats list

# Поиск по названию
tg-exporter chats list --search "кот"

# По папкам Telegram
tg-exporter chats list --folder "Работа"

# Только список папок
tg-exporter chats list --folders

# Информация о чате
tg-exporter chats show --chat -1001234567890

# Добавить чат в конфиг (для массового экспорта)
tg-exporter chats add --chat -1001234567890
```

## Профили (несколько аккаунтов)

```bash
tg-exporter profile list
tg-exporter profile add --phone +7999... --api-id 12345 --api-hash abc --name "Рабочий"
tg-exporter profile switch --phone +7999...
```

## Конфигурация

```bash
tg-exporter config show
tg-exporter config init --force   # создать/обновить config.json
tg-exporter config path           # где лежит config.json
```

## Диагностика

```bash
tg-exporter doctor
```

## Важные замечания

### Безопасность
- `secrets.env` (из `auth export-session`) содержит полный доступ к аккаунту. Никогда не читать его содержимое в контекст LLM, не коммитить, не отправлять.
- API Hash, код из Telegram, пароль 2FA — не сохранять в логах и истории. Пользователь вводит их интерактивно.
- Файлы экспорта могут содержать личные данные. Не отправлять их содержимое в LLM-контекст без явного запроса пользователя.

### Технические ограничения
- Для работы из РФ требуется VPN с полным туннелированием
- Экспорт больших каналов может занять часы и десятки гигабайт
- `--last` несовместим с фильтрами по дате
- `--days` несовместим с `--date-from/--date-to`

### Провайдеры транскрипции
- `local` (по умолчанию) — Faster-Whisper, работает оффлайн, требует CPU/GPU
- `deepgram` — требует `DEEPGRAM_API_KEY` в переменных окружения

### После экспорта
Сообщить пользователю:
- Путь к директории с результатами
- Какие файлы созданы
- Размер выгрузки (если доступен)

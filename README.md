# Telegram Exporter Skill

Скилл для AI-агентов (OpenClaw, Cursor, Claude, OpenCode и др.) для экспорта данных из Telegram-каналов и чатов через консольную утилиту [tg-exporter](https://github.com/MrDerunov/telegram-exporter).

## Что умеет скилл

- Автоматически проверяет наличие `tg-exporter` и устанавливает при необходимости
- Проверяет готовность окружения (авторизация, конфиг, ffmpeg)
- Экспорт чатов в JSON и Markdown с фильтрами по датам и объёму
- Скачивание медиа, транскрипция голосовых, сбор аналитики
- Массовый экспорт всех чатов из конфига
- Инкрементальный экспорт (только новые сообщения)

## Установка

```bash
# OpenClaw
openclaw skill install MrDerunov/telegram-exporter-skill

# Или скачать .skill файл из релизов:
# https://github.com/MrDerunov/telegram-exporter-skill/releases
```

## Требования

- Утилита [tg-exporter](https://github.com/MrDerunov/telegram-exporter) (скачивается автоматически при первом использовании скилла)
- Учётная запись Telegram с API ID и API Hash (my.telegram.org)
- Для работы из РФ — VPN с полным туннелированием

## Структура

```
├── SKILL.md                         # Основной файл скилла
├── scripts/
│   ├── install_tg_exporter.sh       # Автоустановка tg-exporter
│   ├── package_skill.py             # Упаковка скилла в .skill
│   └── quick_validate.py            # Валидация скилла
└── references/
    ├── commands.md                  # Полный справочник команд
    ├── auth_guide.md                # Гайд по авторизации
    └── export_workflows.md          # Типовые сценарии экспорта
```

## Лицензия

MIT — см. [LICENSE](LICENSE) в репозитории [tg-exporter](https://github.com/MrDerunov/telegram-exporter).

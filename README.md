# Telegram Exporter Skill

Скилл для AI-агентов (OpenClaw, Cursor, Claude и др.) для экспорта данных из Telegram-каналов и чатов через десктопное приложение [Telegram Exporter](https://github.com/MrDerunov/telegram-exporter).

## Что такое Telegram Exporter

Десктопное приложение с графическим интерфейсом (tkinter/customtkinter) для:
- Экспорта чатов и каналов в JSON и Markdown
- Транскрипции голосовых сообщений (Whisper / Deepgram)
- Скачивания медиа (фото, видео, документы)
- Аналитики (топ авторов, активность по датам)
- Работы с несколькими аккаунтами

## Установка

```bash
# OpenClaw
openclaw skill install MrDerunov/telegram-exporter-skill

# Или скачать .skill файл из релизов:
# https://github.com/MrDerunov/telegram-exporter-skill/releases
```

## Требования

- Приложение [Telegram Exporter](https://github.com/MrDerunov/telegram-exporter/releases) (скачать бинарник под свою ОС)
- Учётная запись Telegram с API ID и API Hash (my.telegram.org)
- Python 3.11+ (если запуск из исходников)
- Для работы из РФ — VPN с полным туннелированием

## Структура

```
├── SKILL.md                         # Основной файл скилла
├── scripts/
│   ├── package_skill.py             # Упаковка скилла в .skill
│   └── quick_validate.py            # Валидация скилла
└── references/
    ├── auth_guide.md                # Гайд по авторизации
    └── export_workflows.md          # Типовые сценарии экспорта
```

## Версия

Актуальная версия приложения: **v2.0.4**

## Лицензия

MIT — см. [LICENSE](LICENSE) в репозитории [telegram-exporter](https://github.com/MrDerunov/telegram-exporter).

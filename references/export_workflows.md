# Типовые сценарии экспорта

## Базовый экспорт

### Экспорт всего чата в JSON + Markdown
```bash
tg-exporter export run --chat @channel_name
```

### Экспорт только в JSON
```bash
tg-exporter export run --chat -1001234567890 --format json
```

### Экспорт только в Markdown
```bash
tg-exporter export run --chat @channel_name --format markdown
```

### Экспорт в конкретную директорию
```bash
tg-exporter export run --chat @channel_name --output /путь/к/директории
```

---

## Фильтры по датам и объёму

### Последние N дней
```bash
tg-exporter export run --chat @channel_name --days 7
```

### Диапазон дат
```bash
tg-exporter export run --chat @channel_name \
  --date-from 2024-01-01 \
  --date-to 2024-12-31
```

### Последние N сообщений (быстрый тест)
```bash
tg-exporter export run --chat @channel_name --last 100
```

⚠️ `--last` не комбинируется с `--date-from/--date-to/--days`.

### Только конкретный топик форума
```bash
tg-exporter export run --chat -1001234567890 --topic-id 42
```

---

## Медиа и транскрипция

### Скачать все медиа
```bash
tg-exporter export run --chat @channel_name --download-media
```
Скачивает фото, видео, голосовые, документы в папки `media/`.

### Транскрипция голосовых (локально Faster-Whisper)
```bash
tg-exporter export run --chat @channel_name --download-media --transcribe
```

### Транскрипция через Deepgram
```bash
tg-exporter export run --chat @channel_name \
  --download-media \
  --transcribe \
  --transcriber deepgram
```

⚠️ Deepgram требует ключ API в переменной окружения `DEEPGRAM_API_KEY`.

---

## Аналитика

### Сбор аналитики по чату
```bash
tg-exporter export run --chat @channel_name --analytics
```
Создаёт `top_authors.md` (топ авторов) и `activity.md` (активность по датам).

---

## Массовый экспорт

### Экспорт всех чатов из конфига
```bash
tg-exporter export run --all --skip-unavailable
```

Предварительно нужно добавить чаты в конфиг:
```bash
# Добавить конкретный чат
tg-exporter chats add --chat -1001234567890

# Добавить все чаты из папки Telegram
tg-exporter chats add --folder "Работа"

# Просмотр списка
tg-exporter chats list
```

### Массовый экспорт с медиа и аналитикой
```bash
tg-exporter export run --all --skip-unavailable \
  --download-media \
  --transcribe \
  --analytics \
  --format json
```

---

## Инкрементальный экспорт

### Продолжить прерванный экспорт
```bash
tg-exporter export run --chat @channel_name --resume
```
Дозабирает только новые сообщения с момента последнего экспорта.

### Регулярный инкрементальный бэкап (cron)
```bash
# Каждый день в 3:00 дозабирать новые сообщения
0 3 * * * cd /путь/к/экспорту && tg-exporter export run --chat @channel_name --resume --download-media
```

---

## CI/CD сценарий

```bash
# 1. Загрузить сессию из secrets.env (должен быть предварительно создан)
export $(cat secrets.env | xargs)

# 2. Проверить что сессия валидна
tg-exporter auth verify

# 3. Экспорт
tg-exporter export run --chat -1001234567890 --last 1000 --format json
```

---

## Структура вывода

После экспорта в директории `<output>/` создаётся:

```
<output>/
├── result.json              # Полный JSON со всеми сообщениями
├── _part_1.md               # Markdown, часть 1
├── _part_2.md               # Markdown, часть 2 (если >50000 слов)
├── media/
│   ├── photos/              # Фото (.jpg, .png)
│   ├── videos/              # Видео и кружки (.mp4)
│   ├── voices/              # Голосовые (.ogg)
│   ├── documents/           # Документы
│   └── stickers/            # Стикеры (.webp)
├── top_authors.md           # Аналитика: топ авторов
├── activity.md              # Аналитика: активность по датам
└── export_history.json      # Метаданные последнего экспорта (для --resume)
```

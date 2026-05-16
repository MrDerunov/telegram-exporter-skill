# Команды tg-exporter — полный справочник

## Группы команд

| Группа | Назначение |
|--------|------------|
| `auth` | Аутентификация в Telegram |
| `export` | Экспорт сообщений |
| `chats` | Просмотр и управление чатами |
| `profile` | Управление аккаунтами (профилями) |
| `config` | Управление конфигурацией |
| `doctor` | Диагностика окружения |
| `version` | Версия утилиты |

---

## auth — Аутентификация

### `tg-exporter auth login`
Интерактивный вход в аккаунт Telegram.
```
--phone TEXT       Номер телефона (+7999...)
--api-id TEXT      Telegram API ID
--api-hash TEXT    Telegram API Hash
--profile TEXT     Имя профиля (default: "default")
```

### `tg-exporter auth status`
Проверить статус авторизации.
```
--profile TEXT     Имя профиля (default: "default")
```

### `tg-exporter auth logout`
Выйти из аккаунта.
```
--profile TEXT     Имя профиля (default: "default")
```

### `tg-exporter auth export-session`
Экспортировать сессию в secrets.exported.env для CI/CD.
```
--output TEXT      Путь к выходному файлу (default: secrets.exported.env)
```

### `tg-exporter auth verify`
Проверить валидность сессии (для CI/CD). Exit code: 0=валидна, 1=невалидна.
```
--profile TEXT     Имя профиля (default: "default")
```

---

## export — Экспорт сообщений

### `tg-exporter export run`
Экспорт сообщений из чата (или всех чатов с --all).

**Выбор чата:**
```
--chat TEXT               ID или username чата/канала
--all                     Экспортировать все чаты из конфига
--skip-unavailable        Пропускать недоступные чаты (с --all)
```

**Фильтры:**
```
--last N                  Экспортировать последние N сообщений
--date-from YYYY-MM-DD    Начало периода
--date-to YYYY-MM-DD      Конец периода
--days N                  Последние N дней (вместо date-from/date-to)
--topic-id ID             ID топика (для форумов)
```

⚠️ `--last` нельзя комбинировать с фильтрами по дате.  
⚠️ `--days` нельзя комбинировать с `--date-from/--date-to`.

**Формат:**
```
--format [json|markdown|both]   Формат экспорта (default: both)
--words-per-file N              Слов на Markdown-файл (default: 50000)
```

**Медиа и транскрипция:**
```
--download-media            Скачивать медиафайлы
--transcribe                Транскрибировать голосовые
--transcriber [local|deepgram]   Провайдер транскрипции (default: local)
```

**Прочее:**
```
--analytics                 Собирать аналитику (top_authors.md, activity.md)
--resume                    Продолжить прерванный экспорт
--output TEXT               Директория для выгрузки
--profile TEXT              Имя профиля (default: "default")
```

---

## chats — Управление чатами

### `tg-exporter chats list`
Список чатов из Telegram.
```
--folder TEXT     Показать чаты только в этой папке
--folders         Показать только список папок
--search TEXT     Поиск по названию чата
```

### `tg-exporter chats show`
Информация о конкретном чате.
```
--chat ID (обязательный)   ID чата
```

### `tg-exporter chats add`
Добавить чат(ы) в конфиг для быстрого доступа.
```
--chat ID         ID чата для добавления
--folder TEXT     Добавить все чаты из папки Telegram
```

### `tg-exporter chats remove`
Убрать чат из конфига.
```
--chat ID (обязательный)   ID чата для удаления
```

---

## profile — Профили аккаунтов

### `tg-exporter profile list`
Список профилей.

### `tg-exporter profile add`
Добавить новый профиль.
```
--phone TEXT (обязательный)     Номер телефона (+7999...)
--api-id TEXT (обязательный)    Telegram API ID
--api-hash TEXT (обязательный)  Telegram API Hash
--name TEXT                     Отображаемое имя профиля
```

### `tg-exporter profile remove`
Удалить профиль.
```
--phone TEXT (обязательный)     Номер телефона профиля
```

### `tg-exporter profile switch`
Переключить активный профиль.
```
--phone TEXT (обязательный)     Номер телефона профиля
```

---

## config — Конфигурация

### `tg-exporter config show`
Показать текущий конфиг.

### `tg-exporter config set`
Установить значение в конфиге.
```
KEY     Ключ (api_id, default_profile, default_format, secrets_source, ...)
VALUE   Значение
```

### `tg-exporter config path`
Показать путь к конфиг-файлу.

### `tg-exporter config init`
Создать config.json с дефолтными значениями.
```
--force, -f    Обновить существующий конфиг (добавить недостающие поля)
```

---

## doctor — Диагностика

### `tg-exporter doctor`
Диагностика окружения: Python, конфиг, state.json, keyring, сессия, ffmpeg, свободное место.

---

## version — Версия

### `tg-exporter version`
Показать версию утилиты.

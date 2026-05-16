# Гайд по авторизации в tg-exporter

## Получение API ключей

1. Перейти на https://my.telegram.org
2. Войти под своим номером телефона
3. Выбрать «API development tools»
4. Создать приложение (если ещё нет)
5. Сохранить **api_id** (число) и **api_hash** (строка)

## Первый вход

```bash
tg-exporter auth login
```

Интерактивно запросит:
1. **API ID** — число из my.telegram.org
2. **API Hash** — строка из my.telegram.org
3. **Номер телефона** — в формате +79991234567
4. **Код из Telegram** — придёт в приложение/смс
5. **Пароль 2FA** — если включена двухфакторная аутентификация

## Проверка статуса

```bash
tg-exporter auth status
# ✅ Авторизован — всё ок, можно экспортировать
# ❌ Не авторизован — нужно выполнить auth login
```

## Выход

```bash
tg-exporter auth logout
```

## Несколько аккаунтов (профили)

```bash
# Добавить второй аккаунт
tg-exporter profile add --phone +79991112233 --api-id 12345 --api-hash abcdef --name "Рабочий"

# Войти под вторым аккаунтом
tg-exporter auth login --profile "Рабочий" --phone +79991112233

# Переключение между профилями
tg-exporter profile switch --phone +79991112233

# Список профилей
tg-exporter profile list
```

## CI/CD режим

Для автоматизации (GitHub Actions, CI):

```bash
# 1. На локальной машине авторизоваться
tg-exporter auth login

# 2. Экспортировать сессию
tg-exporter auth export-session --output secrets.exported.env
# → создаст secrets.exported.env с TG_EXPORTER_API_ID, TG_EXPORTER_API_HASH, TG_EXPORTER_SESSION

# 3. В CI передать содержимое secrets.exported.env как переменные окружения
# 4. Проверить валидность сессии
tg-exporter auth verify
```

⚠️ `secrets.exported.env` содержит полный доступ к аккаунту Telegram. Хранить в безопасном месте, не коммитить в репозиторий.

## Диагностика проблем

```bash
# Полная диагностика
tg-exporter doctor
```

Проверяет:
- Наличие конфига (`config.json`)
- Состояние (`state.json`)
- Доступность keyring
- Валидность сессии
- Наличие ffmpeg (для транскрипции)
- Свободное место на диске

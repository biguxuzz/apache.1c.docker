## Apache + 1C Web Server (VRD) в Docker (Windows + WSL + Docker Desktop)

### Требования
- Windows 10/11
- WSL2 (любая дистрибуция, рекомендован Ubuntu)
- Docker Desktop с включенной WSL2 интеграцией

### Что делает контейнер
- Поднимает Apache с модулем 1C Web Server (`wsap24.so`)
- Публикует VRD из шаблона `www/base/default.vrd.tpl`
- На старте генерирует VRD `/run/1c/default.vrd` подставляя переменные из `.env`

### Переменные окружения (.env)
Создайте файл `.env` рядом с `docker-compose.yaml`:

```env
# Имя/адрес сервера 1С (Srvr)
IB_SERVER=PGORODILOV.WSL

# Имя базы 1С (Ref)
IB_NAME=lock_test

# Путь на хосте к каталогу с платформе 1C для debian систем
# по релизу совпадающей с платформой 1С сервера приложений
# Должен содержать файл wsap24.so и его зависимости
# Пример: относительный путь к папке внутри проекта
ONEC_DIR=D:\git\apache.1c.docker\platform\8.3.27.1644
```

Файл `.env` добавлен в `.gitignore` и не попадёт в репозиторий.

### Подготовка каталога платформы 1С для модуля Web Server
1. Создайте папку `platform` в корне проекта (или укажите иной путь в `ONEC_DIR`).
2. Поместите в неё файл `wsap24.so` и все необходимые библиотечные зависимости соответствующей версии 1С.
3. Внутри контейнера этот каталог будет доступен по пути `/opt/1cv8/platform` (см. `apache/1cws.load`).

> Примечание: путь `ONEC_DIR=./platform` относительно корня репозитория. Можно задать абсолютный путь Windows (например, `D:\1c\platform`) — Docker Desktop корректно смонтирует его в контейнер (бэкэнд WSL2).

### Сборка и запуск
```bash
docker compose build
docker compose up -d
```

Откройте `http://localhost/base`.

### Проверка и логи
```bash
docker compose ps
docker compose logs -f
```

### Изменение настроек
Правьте `.env` (например, `IB_SERVER`/`IB_NAME`) и перезапускайте контейнер:
```bash
docker compose up -d
```

При каждом старте контейнера VRD пересобирается из шаблона `www/base/default.vrd.tpl` в `/run/1c/default.vrd`.

### Остановка и удаление
```bash
docker compose down
```

### Структура
- `config/000-default.conf` — Apache, указывает `ManagedApplicationDescriptor "/run/1c/default.vrd"`
- `www/base/default.vrd.tpl` — шаблон VRD с переменными `${IB_SERVER}` и `${IB_NAME}`
- `entrypoint.sh` — генерирует VRD через `envsubst` и запускает Apache
- `docker-compose.yaml` — монтирует конфиги/VRD, подключает `.env`, задаёт ресурсы
- `apache/1cws.load` — загрузка модуля `wsap24.so` из `/opt/1cv8/platform`




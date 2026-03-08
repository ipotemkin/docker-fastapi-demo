# Docker FastAPI Demo

Демо-проект: бэкенд на FastAPI и фронтенд на nginx + HTML, запуск через Docker
Compose.

## Структура проекта

```
├── backend/           # FastAPI-приложение
│   ├── app/
│   │   └── main.py
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/          # Статика + nginx
│   ├── index.html
│   ├── nginx.conf
│   └── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```

## Требования

- Docker и Docker Compose
- Для локального запуска бэкенда: Python 3.11+, pip

## Быстрый старт

```bash
make up
```

Фронтенд: **http://localhost:8080**  
Swagger API (через прокси): **http://localhost:8080/api/v1**

Остановка:

```bash
make down
```

## API (бэкенд)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/api/v1` | Swagger UI |
| GET | `/api/v1/info` | Информация о системе (Python, платформа) |
| GET | `/api/v1/healthcheck` | Проверка доступности |
| GET | `/api/v1/calc/{a}/{b}` | Сложение двух чисел |
| GET | `/api/v1/subtract/{a}/{b}` | Вычитание (a − b) |
| GET | `/metrics` | Метрики Prometheus (для мониторинга) |

## Makefile

| Команда | Действие |
|---------|----------|
| `make` / `make help` | Справка по целям |
| `make up` | Запустить сервисы |
| `make down` | Остановить контейнеры |
| `make build` | Пересобрать образы |
| `make restart` | Перезапустить сервисы |
| `make logs` | Логи в реальном времени |
| `make ps` | Список контейнеров |
| `make clean` | Остановить и удалить образы/тома проекта |
| `make shell-backend` | Shell в контейнере backend |
| `make shell-frontend` | Shell в контейнере frontend |

## Локальный запуск бэкенда (без Docker)

```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

API: http://localhost:8000 (Swagger: http://localhost:8000/api/v1).

## CI/CD (GitHub Actions)

При пуше в `main` или по ручному запуску workflow:

1. Собираются образы backend и frontend.
2. Образы пушатся в registry (`194.87.130.247:5000`) с тегом по короткому SHA и `latest`.
3. По SSH выполняется деплой на удалённый сервер: `docker compose -f docker-compose.prod.yml pull && up -d`.

### Секреты репозитория (Settings → Secrets and variables → Actions)

| Секрет | Описание |
|--------|----------|
| `REGISTRY_USERNAME` | Логин для Docker registry |
| `REGISTRY_PASSWORD` | Пароль для Docker registry |
| `SSH_HOST` | Хост удалённого сервера (IP или домен) |
| `SSH_USER` | Пользователь для SSH |
| `SSH_PRIVATE_KEY` | Приватный SSH-ключ (полное содержимое) |
| `DEPLOY_PATH` | (опционально) Каталог на сервере с клоном репо; по умолчанию `~/docker-fatsapi-demo` |

### Однократная подготовка сервера

1. Установить Docker и Docker Compose.
2. Клонировать репозиторий в выбранный каталог, например:  
   `git clone <url> ~/docker-fatsapi-demo && cd ~/docker-fatsapi-demo`
3. Убедиться, что в каталог деплоя попал файл `docker-compose.prod.yml` (он в репо).
4. Настроить доступ по SSH ключу для пользователя из `SSH_USER`.
5. Registry работает по **HTTP**. На сервере нужно разрешить небезопасный registry:  
   в `/etc/docker/daemon.json` добавить  
   `"insecure-registries": ["194.87.130.247:5000"]`,  
   затем `sudo systemctl restart docker`.

### Логирование и мониторинг (Loki, Prometheus, Grafana)

В production compose подняты **Loki**, **Prometheus**, **cAdvisor**, **Grafana** и **Promtail**.

- **Логи:** Promtail собирает логи контейнеров backend и frontend и отправляет их в Loki.
  В Grafana выберите источник Loki и запрос по лейблу: `{container="demo-backend"}` или
  `{container="demo-frontend"}`.
- **Метрики:** бэкенд отдаёт Prometheus-метрики по адресу `/metrics` (счётчики запросов,
  латентность, статусы). Prometheus их забирает. cAdvisor отдаёт метрики контейнеров
  (CPU, память, сеть). В Grafana доступен дашборд **«Backend & Frontend metrics»** с
  основными метриками: RPS и латентность API, статусы ответов, загрузка CPU/память и сеть
  по контейнерам backend и frontend.

- **Grafana:** http://&lt;сервер&gt;:3000 (логин/пароль по умолчанию: `admin` / `admin`;
  задаётся через `GRAFANA_ADMIN_USER` и `GRAFANA_ADMIN_PASSWORD` в `.env`).
- **Prometheus:** http://&lt;сервер&gt;:9090 (UI для проверки таргетов и запросов).
- **Loki:** порт 3100 (доступ через Grafana).

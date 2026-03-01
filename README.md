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

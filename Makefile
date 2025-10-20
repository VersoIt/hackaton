.PHONY: help up down build restart logs clean test backend-shell frontend-shell db-shell redis-shell migrate db-reset

help: ## Показать эту справку
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Запустить все сервисы
	docker-compose up -d

down: ## Остановить все сервисы
	docker-compose down

build: ## Пересобрать все образы
	docker-compose build

rebuild: ## Пересобрать и запустить
	docker-compose up -d --build

restart: ## Перезапустить все сервисы
	docker-compose restart

logs: ## Показать логи всех сервисов
	docker-compose logs -f

logs-backend: ## Показать логи backend
	docker-compose logs -f backend

logs-frontend: ## Показать логи frontend
	docker-compose logs -f frontend

clean: ## Удалить контейнеры и volumes
	docker-compose down -v

clean-all: ## Удалить всё (контейнеры, volumes, образы)
	docker-compose down -v --rmi all

backend-shell: ## Войти в контейнер backend
	docker-compose exec backend sh

frontend-shell: ## Войти в контейнер frontend
	docker-compose exec frontend sh

db-shell: ## Войти в PostgreSQL
	docker-compose exec postgres psql -U postgres -d hackathon_db

redis-shell: ## Войти в Redis CLI
	docker-compose exec redis redis-cli

ps: ## Показать статус контейнеров
	docker-compose ps

test-backend: ## Запустить тесты backend
	docker-compose exec backend go test ./...

test-frontend: ## Запустить тесты frontend
	docker-compose exec frontend npm test

migrate: ## Запустить миграции БД
	docker-compose exec backend go run cmd/migrate/main.go

db-reset: ## Сбросить БД
	docker-compose exec postgres psql -U postgres -c "DROP DATABASE IF EXISTS hackathon_db;"
	docker-compose exec postgres psql -U postgres -c "CREATE DATABASE hackathon_db;"
	$(MAKE) migrate

install-backend: ## Установить зависимости backend
	cd backend && go mod download

install-frontend: ## Установить зависимости frontend
	cd frontend && npm install

dev-backend: ## Запустить backend локально (без Docker)
	cd backend && go run cmd/api/main.go

dev-frontend: ## Запустить frontend локально (без Docker)
	cd frontend && npm run dev

format-backend: ## Форматировать код backend
	cd backend && gofmt -w .

format-frontend: ## Форматировать код frontend
	cd frontend && npm run format

lint-backend: ## Проверить код backend
	cd backend && golangci-lint run

lint-frontend: ## Проверить код frontend
	cd frontend && npm run lint
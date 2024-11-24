ifneq (,$(wildcard ./.env))
include .env
export
ENV_FILE_PARAM = --env-file .env
else
  $(error .env file not found or empty)
endif

build:
	docker compose up --build --remove-orphans

up:
	docker compose up -d

down:
	docker compose down

down-v:
	docker compose down -v

show-logs:
	docker compose logs -f

security-logs:
	docker compose exec web tail -f logs/security.log

shell:
	docker compose exec web python3 manage.py shell

migrate:
	docker compose exec web python3 manage.py migrate

makemigrations:
	docker compose exec web python3 manage.py makemigrations

superuser:
	docker compose exec web python3 manage.py createsuperuser

collectstatic:
	docker compose exec web python3 manage.py collectstatic --no-input --clear

volume:
	docker volume inspect postgres_data

ebook-db:
	docker compose exec db psql --username=postgres --dbname=ebook-api

test:
	docker compose exec web pytest -p no:warnings --cov=.

test-html:
	docker compose exec web pytest -p no:warnings --cov=. --cov-report html

flake8:
	docker compose exec web flake8 .

black-check:
	docker compose exec web black --check --exclude=migrations .

black-diff:
	docker compose exec web black --diff --exclude=migrations .

black:
	docker compose exec web black --exclude=migrations .

isort-check:
	docker compose exec web isort . --check-only --skip env --skip migrations

isort-diff:
	docker compose exec web isort . --diff --skip env --skip migrations

isort:
	docker compose exec web isort . --skip env --skip migrations
#!make
ifneq (,$(wildcard ./.env))
    include .env
    export
endif
.PHONY: python-requirements setup-venv setup test run setup-env makemigrations migrate manage check fmt run-docker run-docker-db stop-docker

CONDA=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate

dot-env:
	cp .env.template .env

setup-conda-python:
	conda remove --name py311-django-example --all
	conda create -n py311-django-example python=3.11

setup-venv:
	rm -rf environment
	$(CONDA) py311-django-example ; python -m venv environment

python-requirements:
	. environment/bin/activate && \
	pip install --upgrade pip && \
	pip install -r requirements.txt && \
	pip install -r requirements_dev.txt && \
	pre-commit install

conda-setup: setup-conda-python setup-venv python-requirements
system-setup: python-requirements

test:
	./manage.py test $(args)

run:
	. environment/bin/activate && \
	./manage.py runserver $(args)

migrations:
	. environment/bin/activate && \
	./manage.py makemigrations $(args)

migrate:
	. environment/bin/activate && \
	./manage.py migrate $(args)

manage:
	. environment/bin/activate && \
	./manage.py $(args)

check:
	. environment/bin/activate && \
	pre-commit run --all-files

fmt:
	. environment/bin/activate && \
	python -m isort .
	python -m black .

build-docker:
	docker compose down
	docker compose build

run-docker:
	docker compose up -d

run-docker-db:
	docker compose up -d client-db

stop-docker:
	docker compose stop

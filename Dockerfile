FROM python:3.12-slim

LABEL maintainer="Ali-Ghotbi"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        postgresql-client \
        build-essential \
        libpq-dev && \
    /py/bin/pip install --default-timeout=100 -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install --default-timeout=100 -r /tmp/requirements.dev.txt; \
    fi && \
    rm -f /tmp/requirements.txt /tmp/requirements.dev.txt && \
    apt-get purge -y --auto-remove build-essential libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --disabled-password --no-create-home --gecos "" django-user

ENV PATH="/py/bin:$PATH"

USER django-user
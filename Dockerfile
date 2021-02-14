FROM python:3.9.1-slim-buster

WORKDIR /app

RUN apt update && apt upgrade -y && apt install -y curl

# Install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

# Copy poetry.lock* in case it doesn't exist in the repo
COPY ./pyproject.toml ./poetry.lock* /app/
COPY ./libs /app/libs
COPY ./scripts /app/scripts

# Allow installing dev dependencies to run tests
ARG INSTALL_DEV=false
RUN bash -c "if [ $INSTALL_DEV == 'true' ] ; then poetry install --no-root; ./scripts/dev_deps.sh; else poetry install --no-root --no-dev ; fi"

COPY ./ /app
ENV PYTHONPATH=/app
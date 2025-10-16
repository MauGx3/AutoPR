FROM python:3.11-slim

# Install git
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Install poetry using pip
ENV POETRY_VERSION=1.7.1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1
RUN pip install --no-cache-dir poetry==${POETRY_VERSION}

# Set up entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root

WORKDIR /app
COPY . .

# Install the app
RUN poetry install

# Run the app
CMD ["/entrypoint.sh"]
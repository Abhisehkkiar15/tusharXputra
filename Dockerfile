FROM python:3.10.8-slim-buster

# System packages install (without musl-dev)
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# App code copy
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir pytube

# Optional ENV
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Start services
CMD ["sh", "-c", "gunicorn app:app & python3 main.py"]

FROM python:3.10-slim-bullseye

# Install required system packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    gcc libffi-dev libssl-dev ffmpeg aria2 curl \
    libcurl4-openssl-dev libxml2 libxslt1-dev mediainfo \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy code
COPY . /app/
WORKDIR /app/

# Install Python dependencies
COPY sainibots.txt /app/sainibots.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r sainibots.txt
RUN pip install --no-cache-dir yt-dlp pytube

# Environment variable
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Start server + bot
CMD ["sh", "-c", "gunicorn app:app & python3 main.py"]

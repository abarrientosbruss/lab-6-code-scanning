FROM python:3.11-slim-bullseye

# Set working directory
WORKDIR /app

# Install system dependencies required for psycopg2 and DNS utilities
# Ensure apt-get update and install are in one RUN command for efficiency/caching.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libpq-dev \
        gcc \
        python3-dev \
        dnsutils && \
    # Clean up APT cache to keep the image size small
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/root/.local/bin:$PATH"

# Upgrade pip and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose port 8000 for Gunicorn
EXPOSE 8000

# Start Gunicorn server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]


# Use a small, modern Python image
FROM python:3.11-slim

# Prevent Python from buffering stdout/stderr & writing .pyc
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8000

# System deps (build essentials for some wheels) – keep minimal
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Workdir
WORKDIR /app

# Install dependencies first for better layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

# Copy app code
COPY . .

# Expose the app port
EXPOSE 8000

# Start with gunicorn; the sample app exposes "app" in app.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]

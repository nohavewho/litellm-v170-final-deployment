# Простой Dockerfile для LiteLLM v1.70.0 Railway Deployment
FROM python:3.11-slim

# Установка переменных окружения
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Установка рабочей директории
WORKDIR /app

# Копирование и установка зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копирование файлов конфигурации
COPY config.yaml .
COPY entrypoint.sh .

# Установка прав на выполнение
RUN chmod +x entrypoint.sh

# Открытие порта
EXPOSE 4000

# Команда запуска
CMD ["./entrypoint.sh"]
# Многоэтапный Dockerfile для LiteLLM v1.70.0 Railway Deployment
# Раздел 2.1: Финальный Dockerfile для фиксации версии

# Этап 1: Сборщик
# Используется конкретная версия Python для воспроизводимости
FROM python:3.11-slim-bullseye AS builder

# Установка переменных окружения для предотвращения интерактивных запросов
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Установка зависимостей для сборки
WORKDIR /app
RUN pip install --upgrade pip

# Копирование только файла requirements.txt для использования кэширования слоев Docker
COPY requirements.txt .

# Установка зависимостей, включая конкретную версию litellm
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

# Этап 2: Финальный образ
FROM python:3.11-slim-bullseye

WORKDIR /app

# Копирование собранных пакетов из этапа сборщика
COPY --from=builder /app/wheels /wheels

# Установка зависимостей из собранных пакетов
RUN pip install --no-cache-dir --find-links /wheels -r /wheels/*.whl

# Очистка временных файлов
RUN rm -rf /wheels

# Копирование файлов конфигурации
COPY config.yaml /app/config.yaml
COPY entrypoint.sh /app/entrypoint.sh

# Создание непривилегированного пользователя для безопасности
RUN groupadd -r litellm && useradd -r -g litellm litellm

# Установка прав доступа
RUN chmod +x /app/entrypoint.sh && \
    chown -R litellm:litellm /app

# Переключение на непривилегированного пользователя
USER litellm

# Открытие порта 4000
EXPOSE 4000

# Команда запуска
CMD ["/app/entrypoint.sh"]
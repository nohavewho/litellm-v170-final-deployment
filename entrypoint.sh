#!/bin/sh
# Entrypoint script для LiteLLM v1.70.0 Railway Deployment
# Запуск прокси LiteLLM с указанием файла конфигурации и порта

echo "🚀 Запуск LiteLLM v1.70.0 Proxy Server"
echo "📁 Конфигурация: /app/config.yaml"
echo "🌐 Порт: 4000"
echo "🔧 Хост: 0.0.0.0"

# Запуск прокси LiteLLM
litellm --config /app/config.yaml --port 4000 --host 0.0.0.0
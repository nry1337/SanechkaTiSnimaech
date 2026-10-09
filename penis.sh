#!/bin/bash

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Ошибка: запустите скрипт с правами root"
  exit 1
fi

CONF="/etc/systemd/resolved.conf"
MAIN_DNS="83.220.169.155"
FALLBACK_DNS="212.109.195.93"

echo "⚙️ Редактируем файл $CONF..."

# Устанавливаем основной DNS
sed -i -E "s/^#?DNS=.*/DNS=$MAIN_DNS/" "$CONF"

# Устанавливаем Fallback DNS
sed -i -E "s/^#?FallbackDNS=.*/FallbackDNS=$FALLBACK_DNS/" "$CONF"

# Устанавливаем глобальный домен маршрутизации
sed -i -E "s/^#?Domains=.*/Domains=~./" "$CONF"

echo "🔄 Перезапускаем службу systemd-resolved..."
systemctl restart systemd-resolved
sleep 1

echo "✅ Готово! Проверяем статус Global DNS:"
resolvectl status | grep -A 5 "Global"

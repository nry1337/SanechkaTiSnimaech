#!/bin/bash

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Ошибка: запустите скрипт с правами root (sudo bash $0)"
  exit 1
fi

CONF="/etc/systemd/resolved.conf"
DNS_IPS="83.220.169.155 212.109.195.93"

echo "⚙️ Редактируем файл $CONF..."

# Снимаем комментарий и прописываем DNS
sed -i -E "s/^#?DNS=.*/DNS=$DNS_IPS/" "$CONF"

# Снимаем комментарий и прописываем Domains=~. (чтобы ваши DNS перебивали гугловские от провайдера)
sed -i -E "s/^#?Domains=.*/Domains=~./" "$CONF"

echo "🔄 Перезапускаем службу systemd-resolved..."
systemctl restart systemd-resolved
sleep 1

echo "✅ Готово! Проверяем статус Global DNS:"
resolvectl status | grep -A 4 "Global"

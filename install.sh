#!/bin/bash

# Переменные
DOWNLOAD_URL="https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/mihomo-linux-amd64-alpha-792f162.gz"
DOWNLOAD_PATH="/tmp/mihomo.gz"
TMP_PATH="/tmp/mihomo"
INSTALL_PATH="/sbin/mihomo"
SERVICE_NAME="mihomo"
SERVICE_FILE="/etc/init.d/${SERVICE_NAME}"
CONFIG_DIR="/etc/mihomo"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"

# Скачивание архива mihomo
echo "Скачивание $DOWNLOAD_URL..."
wget -O "$DOWNLOAD_PATH" "$DOWNLOAD_URL"

# Распаковка архива и установка mihomo
echo "Распаковка $DOWNLOAD_PATH..."
gzip -d "$DOWNLOAD_PATH"
mv "$TMP_PATH" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

# Записываем базовый файл конфигурации
mkdir -p "$CONFIG_DIR"
cat <<EOF > $CONFIG_FILE
port: 7890
socks-port: 7891
allow-lan: true
mode: rule
external-controller: 0.0.0.0:9090

proxies:
  - name: "Proxy"
    type: vmess
    server: your-v2ray-server.com
    port: 443
    uuid: "your-uuid"
    alterId: 0
    cipher: auto

rules:
  - MATCH,Proxy
EOF

# Создание файла службы для OpenRC
echo "Создание файла службы для OpenRC..."

cat <<EOF > $SERVICE_FILE
#!/sbin/openrc-run

description="Mihomo Daemon - Another Clash Kernel"
command="$INSTALL_PATH"
command_args="-d $CONFIG_DIR"
command_background=true
pidfile="/run/$SERVICE_NAME.pid"

depend() {
    need net
    after networkmanager
}

start_pre() {
    ebegin "Waiting before starting $SERVICE_NAME"
    sleep 1
    eend $?
}
EOF

# Настройка прав для запуска
chmod +x $SERVICE_FILE

# Добавление в автозагрузку и запуск службы
echo "Добавление службы в автозагрузку и её запуск..."
rc-update add $SERVICE_NAME default
rc-service $SERVICE_NAME start

echo "Установка завершена."
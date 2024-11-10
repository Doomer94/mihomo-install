# Mihomo Installer Script for Alpine Linux (OpenRC)

Этот скрипт устанавливает, настраивает и запускает сервис `mihomo` — службу для управления интернет-прокси и маршрутизации на основе конфигураций, аналогичных Clash.

## Описание

Скрипт `install.sh` выполняет следующие действия:

1. **Скачивает** бинарный файл `mihomo` из [репозитория GitHub](https://github.com/MetaCubeX/mihomo).
2. **Распаковывает и устанавливает** его в `/sbin/mihomo`.
3. **Создает конфигурационный файл** `/etc/mihomo/config.yaml` с базовыми настройками.
4. **Настраивает службу** OpenRC, чтобы `mihomo` автоматически запускался при старте системы.
5. **Добавляет службу в автозагрузку** и запускает её.

## Требования

* Alpine Linux с OpenRC
* Интернет-соединение для загрузки файла

## Установка

1. Скачайте и запустите скрипт `install.sh`:
   ``` bash
   wget -O install.sh https://raw.githubusercontent.com/Doomer94/mihomo-install/main/install.sh
   chmod +x install.sh
   sh./install.sh
   ```
2. Скрипт выполнит следующие действия:
   * Скачает и установит `mihomo`.
   * Создаст базовую конфигурацию в `/etc/mihomo/config.yaml`.
   * Настроит службу для управления через `OpenRC`.

## Конфигурация

Базовая конфигурация сохраняется в `/etc/mihomo/config.yaml` и включает:

``` yaml
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
```


Параметры можно изменить по мере необходимости. Например, обновите `server`, `uuid` и другие данные прокси-сервера.

## Управление службой

Используйте следующие команды для управления `mihomo`:

* Запустить службу:
``` bash
sudo rc-service mihomo start
```
* Остановить службу:
``` bash
sudo rc-service mihomo stop
``` 
* Перезапустить службу:
``` bash
sudo rc-service mihomo restart
```
* Добавить `mihomo` в автозагрузку:
``` bash
sudo rc-update add mihomo default
```

## Удаление

Для удаления `mihomo`:

1. Остановите службу:
``` bash
rc-service mihomo stop
```
2. Удалите файлы:
``` bash
rm /sbin/mihomo
rm /etc/init.d/mihomo
rm -rf /etc/mihomo
```


## Примечание

Данный скрипт настроен для использования с OpenRC и будет работать только в системах, совместимых с OpenRC, таких как Alpine Linux.

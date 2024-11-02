#!/bin/bash

# Backups a serem removidos
backups=("/data/backup/aplicacao/localhost/daily.4" "/data/backup/aplicacao/localhost/daily.5")

# Arquivo de log
log_file="/var/log/cleanup_backup.log"

# Função para remover backups
cleanup_backup() {
    for bkp in "${backups[@]}"; do
        if [ -d "$bkp" ]; then
            rm -rf "$bkp"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Diretório removido: $bkp" >> "$log_file"
            sleep 900
        fi
    done
}

# Loop infinito para monitorar continuamente
while true; do
    if [ -d "/data/backup/aplicacao/localhost/daily.5" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup 'daily.5' encontrado. Removendo diretórios especificados." >> "$log_file"
        cleanup_backup
    fi
    sleep 120
done

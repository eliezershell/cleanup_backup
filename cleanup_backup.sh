#!/bin/bash

### Variáveis ###
# Backups a serem removidos:
backup4="/data/backup/aplicacao/localhost/daily.4"
backup5="/data/backup/aplicacao/localhost/daily.5"
# Arquivo de log:
log_file="/var/log/cleanup_backup.log"

# Função para remover backups
cleanup_backup() {
	# Exclusão do Bakup daily.4
	if [ -d "backup4 "]; then
		rm -rf "$backup4"
		echo "$(TZ='Etc/GMT+3' date '+%d-%m-%Y %H:%M:%S GMT-3') - Diretório removido: $backup4" >> "$log_file"
	else
		echo "$(TZ='Etc/GMT+3' date '+%d-%m-%Y %H:%M:%S GMT-3') - Diretório $backup4 não encontrado, portanto não foi excluído." >> "$log_file"
	fi

	# Exclusão do backup daily.5
	while true; do
		previous_size=$(du -sb "$backup5" | awk '{print $1}')
		sleep 300
		if [ ! -d "$backup5" ]; then
			echo "$(TZ='Etc/GMT+3' date '+%d-%m-%Y %H:%M:%S GMT-3') - Diretório $backup5 não encontrado, portanto não foi excluído." >> "$log_file"
			break
		fi
		current_size=$(du -sb "$backup5" | awk '{print $1}')
		if [ "$previous_size" -eq "$current_size" ]; then
			rm -rf "$backup5"
			echo "$(TZ='Etc/GMT+3' date '+%d-%m-%Y %H:%M:%S GMT-3') - Diretório removido: $backup5" >> "$log_file"
			break
		fi
	done
}

# Loop infinito para monitorar continuamente
while true; do
	if [ -d "/data/backup/aplicacao/localhost/daily.5" ]; then
		echo "$(TZ='Etc/GMT+3' date '+%d-%m-%Y %H:%M:%S GMT-3') - Backup 'daily.5' encontrado. Removendo diretórios especificados." >> "$log_file"
		cleanup_backup
	fi
	sleep 120
done

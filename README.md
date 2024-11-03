# Backup Cleaner Service

Este repositório contém um script de limpeza automatizada de backups antigos, projetado para ser executado como um serviço *systemd*. O script verifica periodicamente se há diretórios de backup específicos e os remove caso sejam encontrados. A execução em segundo plano permite manter o sistema de backups organizado sem intervenção manual.

## Propósito

Este serviço verifica se o backup diário `/data/backup/aplicacao/localhost/daily.5` existe e, se for encontrado, remove os backups `/data/backup/aplicacao/localhost/daily.5` e `/data/backup/aplicacao/localhost/daily.4`. É uma ferramenta útil para administrar backups rotativos em sistemas onde o espaço de armazenamento é limitado ou onde backups antigos precisam ser limpos regularmente.

## Pré-requisitos

- Sistema Linux com *systemd*.
- Permissões de superusuário para instalação e configuração do serviço.

## Estrutura do Repositório

- `cleanup_backup.sh`: Script de limpeza de backups.
- `cleanup.backup.service`: Arquivo de unidade *systemd* para gerenciar o script como serviço.
- `README.md`: Este arquivo de documentação.

## Instalação

### Passo 1: Configurar o Script

1. Clone o repositório:

   ```bash
   git clone https://github.com/eliezershell/cleanup_backup.git
   cd cleanup_backup
   ```

2. Torne o script executável:

   ```bash
   chmod +x cleanup_backup.sh
   ```

### Passo 2: Criar o Arquivo de Log

Certifique-se de criar o diretório e o arquivo de log que o script usará para registrar as operações:

```bash
sudo touch /var/log/cleanup_backup.log
sudo chmod 664 /var/log/cleanup_backup.log
```

### Passo 3: Mover o Script para o Diretório de Scripts do Sistema

Para organização, mova o script para o diretório `/usr/local/bin`, onde scripts de uso geral são mantidos:

```bash
sudo mv cleanup_backup.sh /usr/local/bin/
```

### Passo 4: Configurar o Arquivo do Serviço *systemd*

Copie o arquivo `cleanup.backup.service` para o diretório de unidades do *systemd*:

   ```bash
   sudo mv cleanup.backup.service /etc/systemd/system/
   ```

### Passo 5: Atualizar as Configurações do *systemd*

1. Após configurar o arquivo de unidade, atualize o *systemd* para reconhecer a nova unidade:

```bash
sudo systemctl daemon-reload
```

2. Inicie o serviço:

```bash
sudo systemctl start cleanup.backup.service
```

3. Para garantir que o serviço seja iniciado automaticamente na inicialização do sistema:

```bash
sudo systemctl enable cleanup.backup.service
```

## Como Usar o Serviço

Agora que o serviço está configurado, você pode usar os seguintes comandos para controlá-lo.

1. Para ver o status atual do serviço:

```bash
sudo systemctl status cleanup.backup.service
```

2. Para parar o serviço manualmente:

```bash
sudo systemctl stop cleanup.backup.service
```

3. Para desativar o serviço, impedindo que ele inicie automaticamente na inicialização:

```bash
sudo systemctl disable cleanup.backup.service
```

3. Visualizar o arquivo de logs:

```bash
tail -f /var/log/cleanup_backup.log
```

Ou, para ver logs do *systemd*:

```bash
journalctl -u cleanup.backup.service
```

4. Se você fez alguma alteração no script ou nas configurações, reinicie o serviço:

```bash
sudo systemctl restart cleanup.backup.service
```

## Observações Finais

1. **Permissões**: Verifique se o script e o arquivo de log têm as permissões adequadas.
2. **Logs**: O arquivo de log `/var/log/cleanup_backup.log` deve estar acessível para que o serviço possa gravar nele.
3. **Testes**: Sempre faça testes para garantir que o serviço funcione conforme o esperado antes de configurar a ativação automática na inicialização.

Agora, você possui um serviço de limpeza de backups configurado e em execução automaticamente com o *systemd*!

Aqui está um modelo de `README.md` para o seu repositório, cobrindo o propósito, instalação e uso do serviço, além de um guia completo de comandos do `systemd` para gerenciar o serviço.

---

# Backup Cleaner Service

Este repositório contém um script de limpeza automatizada de backups antigos, projetado para ser executado como um serviço *systemd*. O script verifica periodicamente se há diretórios de backup específicos e os remove caso sejam encontrados. A execução em segundo plano permite manter o sistema de backups organizado sem intervenção manual.

## Propósito

Este serviço verifica se o diretório `daily.5` existe e, se for encontrado, remove os diretórios `daily.5`, `daily.4`, `daily.3` e `daily.2` especificados no script. É uma ferramenta útil para administrar backups rotativos em sistemas onde o espaço de armazenamento é limitado ou onde backups antigos precisam ser limpos regularmente.

## Pré-requisitos

- Sistema Linux com *systemd*.
- Permissões de superusuário para instalação e configuração do serviço.

## Estrutura do Repositório

- `backup_cleaner.sh`: Script de limpeza de backups.
- `backup_cleaner.service`: Arquivo de unidade *systemd* para gerenciar o script como serviço.
- `README.md`: Este arquivo de documentação.

## Instalação

### Passo 1: Configurar o Script

1. Clone o repositório:

   ```bash
   git clone https://github.com/seu_usuario/nome_repositorio.git
   cd nome_repositorio
   ```

2. Torne o script executável:

   ```bash
   chmod +x backup_cleaner.sh
   ```

3. (Opcional) Edite o script `backup_cleaner.sh` se necessário para alterar os caminhos dos diretórios de backup.

### Passo 2: Criar o Arquivo de Log

Certifique-se de criar o diretório e o arquivo de log que o script usará para registrar as operações:

```bash
sudo mkdir -p /var/log
sudo touch /var/log/verifica_diretorios.log
sudo chmod 664 /var/log/verifica_diretorios.log
```

### Passo 3: Mover o Script para o Diretório de Scripts do Sistema

Para organização, mova o script para o diretório `/usr/local/bin`, onde scripts de uso geral são mantidos:

```bash
sudo mv backup_cleaner.sh /usr/local/bin/
```

### Passo 4: Configurar o Arquivo do Serviço *systemd*

1. Copie o arquivo `backup_cleaner.service` para o diretório de unidades do *systemd*:

   ```bash
   sudo cp backup_cleaner.service /etc/systemd/system/
   ```

2. Atualize o arquivo de unidade, se necessário:

   - **ExecStart**: Verifique se o caminho para o script `backup_cleaner.sh` está correto.
   - **After=network.target**: Esse parâmetro garante que o serviço será iniciado após a inicialização da rede. Se o script não depende da rede, você pode remover ou ajustar este parâmetro.

### Passo 5: Atualizar as Configurações do *systemd*

Após configurar o arquivo de unidade, atualize o *systemd* para reconhecer a nova unidade:

```bash
sudo systemctl daemon-reload
```

## Como Usar o Serviço

Agora que o serviço está configurado, você pode usar os seguintes comandos para controlá-lo.

### Iniciar o Serviço

Para iniciar o serviço manualmente:

```bash
sudo systemctl start backup_cleaner.service
```

### Ativar o Serviço na Inicialização

Para garantir que o serviço seja iniciado automaticamente na inicialização do sistema:

```bash
sudo systemctl enable backup_cleaner.service
```

### Verificar o Status do Serviço

Para ver o status atual do serviço:

```bash
sudo systemctl status backup_cleaner.service
```

### Parar o Serviço

Para parar o serviço manualmente:

```bash
sudo systemctl stop backup_cleaner.service
```

### Desativar o Serviço

Para desativar o serviço, impedindo que ele inicie automaticamente na inicialização:

```bash
sudo systemctl disable backup_cleaner.service
```

### Ver Logs do Serviço

Os logs do serviço podem ser visualizados diretamente no arquivo de log:

```bash
tail -f /var/log/verifica_diretorios.log
```

Ou, para ver logs do *systemd*:

```bash
journalctl -u backup_cleaner.service
```

### Reiniciar o Serviço

Se você fez alguma alteração no script ou nas configurações, reinicie o serviço:

```bash
sudo systemctl restart backup_cleaner.service
```

## Exemplo de Arquivo `backup_cleaner.service`

Abaixo está um exemplo de como o arquivo `backup_cleaner.service` deve estar configurado:

```ini
[Unit]
Description=Serviço de Limpeza de Backups Antigos
After=network.target

[Service]
ExecStart=/usr/local/bin/backup_cleaner.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

- **Description**: Descreve o serviço para facilitar a identificação.
- **After**: Define a ordem de inicialização do serviço em relação aos outros serviços.
- **ExecStart**: O caminho completo para o script que será executado.
- **Restart**: Garante que o serviço seja reiniciado em caso de falha.
- **WantedBy**: Define o alvo para inicialização (neste caso, `multi-user.target`).

## Observações Finais

1. **Permissões**: Verifique se o script e o arquivo de log têm as permissões adequadas.
2. **Logs**: O arquivo de log `/var/log/verifica_diretorios.log` deve estar acessível para que o serviço possa gravar nele.
3. **Testes**: Sempre faça testes para garantir que o serviço funcione conforme o esperado antes de configurar a ativação automática na inicialização.

Agora, você possui um serviço de limpeza de backups configurado e em execução automaticamente com o *systemd*!

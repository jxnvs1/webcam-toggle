# Webcam Toggle

Um script Bash para ativar ou desativar a webcam interna de laptops. Ele oferece um tutorial para identificar a webcam, mantém um log das ações realizadas e facilita a reversão do estado da webcam.

## Recursos

- **Ativar ou Desativar**: Controle total sobre o estado da webcam.
- **Tutorial de Identificação**: Ajuda o usuário a encontrar o `idVendor` e o `idProduct` da webcam.
- **Log de Ações**: Registra todas as alterações feitas no sistema.
- **Facilidade de Uso**: Reutiliza informações do log para simplificar execuções futuras.

## Requisitos

- Linux com suporte ao UDEV.
- Permissões de administrador (root).

## Como Usar

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/webcam-toggle.git
   cd webcam-toggle
   chmod +x webcam_toggle.sh
   sudo ./webcam_toggle.sh

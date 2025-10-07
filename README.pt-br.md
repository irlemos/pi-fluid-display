🌐 Disponível em: [English](README.md) | [Português BR](README.pt-br.md)

# PiFluidDisplay

### Transforme um Raspberry Pi em uma tela secundária sem fio, universal e inteligente.

Bem-vindo ao PiFluidDisplay! Este projeto de código aberto transforma um Raspberry Pi (funciona com qualquer modelo) e um monitor em um receptor de tela VNC robusto e flexível. Ele foi projetado para ser controlado por qualquer dispositivo na rede, permitindo espelhar a tela do seu celular Android ou um computador Windows, Linux ou macOS.

## ✨ Funcionalidades Principais

* **Instalação Automática ("Zero-Touch"):** Configure seu Raspberry Pi uma única vez. Basta copiar os arquivos para o cartão SD, e o Pi se instala e configura sozinho no primeiro boot.
* **Tela de Espera Inteligente:** Quando ocioso, o Pi exibe uma tela de status personalizável com informações úteis como nome da tela, endereço IP e hostname, facilitando a conexão.
* **Arquitetura Estável ("Single X Session"):** O ambiente gráfico do Pi é iniciado apenas uma vez no boot e nunca é desligado. O sistema apenas alterna entre a tela de espera e o cliente VNC, evitando a reinicialização constante de drivers de vídeo, o que garante máxima estabilidade.
* **Receptor Universal:** Projetado para receber conexões de múltiplos sistemas operacionais. Scripts de controle prontos para **Windows** e **Android (Termux)** estão incluídos.
* **Mecanismo de Recuperação:** Se algo der errado na instalação, basta criar um arquivo `reinstall.txt` no cartão SD e reiniciar o Pi para uma reinstalação de fábrica automática.

## 🏛️ O Conceito: Receptor Universal

A filosofia do PiFluidDisplay é simples: o **Raspberry Pi é um receptor passivo e inteligente**. Ele não se importa de onde vem o sinal, desde que o dispositivo "controlador" possa fazer duas coisas:

1.  **Rodar um servidor VNC:** Para transmitir a imagem da tela.
2.  **Enviar um comando SSH:** Para "acordar" o Pi e dizer a ele para se conectar.

Isso significa que **qualquer sistema operacional** pode se tornar um controlador.

* **Windows:** Sim (script `.bat` fornecido).
* **Android:** Sim (script de shell para Termux fornecido).
* **macOS ou outro PC Linux:** Sim. A arquitetura é a mesma: basta ter um servidor VNC rodando e enviar o comando SSH apropriado para o Pi, instruindo-o a se conectar ao seu IP.

Exemplo de comando para um controlador Linux/macOS:
```bash
ssh -t pi@<IP_DO_PI> "/home/pi/pi-fluid-display/pfd-connect.sh '<IP_DO_SEU_PC>'"
```

---

## 🚀 Guia de Instalação e Uso

### **Parte 1: O Receptor (Configuração do Raspberry Pi)**

Esta configuração é feita uma única vez.

#### **Pré-requisitos:**
* Um Raspberry Pi (qualquer modelo com Wi-Fi/Ethernet).
* Um cartão MicroSD (8GB ou mais).
* Um monitor.
* Uma fonte de alimentação.

#### **Instruções de Instalação Automática:**

1.  **Grave a Imagem do SO:** Use o "Raspberry Pi Imager" para gravar a imagem mais recente do **Raspberry Pi OS Lite** (32-bit ou 64-bit) no cartão SD.
    * **Dica:** Nas opções avançadas do Imager (ícone da engrenagem ⚙️), você já pode configurar sua rede Wi-Fi, habilitar o SSH e definir uma senha para o usuário `pi`, facilitando o processo.

2.  **Copie os Arquivos do Projeto:** Após a gravação, a partição `boot` (ou `bootfs`) aparecerá no seu computador.
    * Dentro desta partição, crie uma nova pasta chamada `pi-fluid-display`.
    * Copie o conteúdo da pasta `raspberry-pi` deste repositório (`install.sh`, `pfd-config.txt.template` e a pasta `files`) para dentro da pasta `pi-fluid-display` que você acabou de criar.

3.  **Personalize seu Dispositivo (Opcional, mas Recomendado):**
    * Dentro da pasta `pi-fluid-display` no cartão, renomeie o arquivo `pfd-config.txt.template` para `pfd-config.txt`.
    * Abra o `pfd-config.txt` com um editor de texto e defina um `DISPLAY_NAME` (nome amigável) e um `HOSTNAME` (nome na rede) para sua tela.

4.  **Ative o Instalador Automático:**
    * Na raiz da partição `boot`, encontre e abra o arquivo `cmdline.txt`.
    * Vá até o final da linha única e longa e adicione o seguinte texto (deixe um espaço antes dele):
        ```
        init=/boot/pi-fluid-display/install.sh
        ```

5.  **Inicie o Pi:** Ejete o cartão SD com segurança, insira-o no Raspberry Pi e ligue-o.
    * A primeira inicialização será mais longa (alguns minutos). O script `install.sh` rodará, instalará todas as dependências, configurará os serviços e reiniciará o Pi automaticamente.
    * Após a segunda inicialização, sua tela de espera personalizada aparecerá. **O seu PiFluidDisplay está pronto!**

---

### **Parte 2: Os Controladores**

#### **Controlador Windows**

1.  **Dependências (instalação única):**
    * **Servidor VNC:** Instale o **UltraVNC Server**. Configure-o para rodar como um serviço automático, **sem senha** e (importante!) transmitindo apenas seu **monitor principal**. Isso é feito nas "Admin Properties" do UltraVNC.
    * **Cliente SSH:** Baixe o programa `plink.exe` do site oficial do [PuTTY](https://putty.org) e coloque-o na mesma pasta onde você salvará o script `pfd-manager.bat`.
2.  **Uso:**
    * Execute o `pfd-manager.bat`. Ele pedirá os IPs e a senha do Pi. Para uma conexão de "um clique", edite o arquivo `.bat` e preencha as variáveis no topo.

#### **Controlador Android (Termux)**

1.  **Dependências (instalação única):**
    * **Servidor VNC:** Instale um app de Servidor VNC da Play Store (ex: "droidVNC-NG") e inicie-o, configurando para acesso **sem senha**.
    * **Termux:** Instale o Termux e, dentro dele, os pacotes `openssh` e `sshpass` com o comando: `pkg install openssh sshpass`.
2.  **Uso:**
    * Copie o script `pfd-manager.sh` para qualquer pasta na sua `home` do Termux.
    * Edite as variáveis no topo ou deixe em branco para que ele pergunte.
    * Execute o script no Termux (ex: `$ ./pfd-manager.sh`).

---

### 🔧 Resolução de Problemas (Troubleshooting)

* **A Instalação Falhou:** Verifique o arquivo de log `pfd-install-log.txt` na partição `boot` do cartão SD para ver mensagens de erro.
* **Tela de Espera Não Aparece:** Conecte-se via SSH e verifique o status do serviço com `sudo systemctl status idle-screen.service`.
* **Reinstalação de Fábrica:** Crie um arquivo vazio chamado `reinstall.txt` na partição `boot` do cartão SD e reinicie o Pi.

---

## 👤 Sobre o Autor

Desenvolvido por [Rodrigo Lemos](https://linkedin.com/in/irlemos)  

💻 **Experiência ampla em desenvolvimento de software, integrações e soluções complexas**  
Com vasta experiência em múltiplas linguagens de programação, plataformas e projetos escaláveis.

---

## 📜 Licença

Este projeto é demonstrativo e faz parte do meu portfólio profissional.  
O uso comercial desta arquitetura requer autorização prévia.
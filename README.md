# 🛠️ Simulador de Ciclo Automatizado - Desafio Mobile
Este aplicativo Flutter simula o ciclo de transporte de materiais em uma mineração, incluindo as etapas de carregamento, deslocamento, basculamento e retorno, o foco está em mostrar a transição automatizada das etapas com base em dados de sensores.


## ✨ Funcionalidades
-O app exibe em tempo real a etapa atual do ciclo.

-Exportação dos dados simulados para um arquivo .jsonl.

-Criação e exclusão do arquivo sync_server.jsonl na pasta **Download** do dispositivo.


## 📱 Uso
Para começar a simulação basta pressionar o botão **Simular** repetidas vezes até o fim do ciclo.
Você pode conferir as etapas registradas expandindo o card clicando no ícone de seta ao lado de **Etapas**.
Ao final do ciclo irá liberar o botão de Exportar, clicando nele, será criado um arquivo na pasta **Download** chamado **sync_servidor.jsonl**
No topo superior direito há um botão para recomeçar a simulação e apagar o arquivo criado na pasta **Download**


## 🧱 Arquitetura
O projeto foi desenvolvido utilizando o padrão MVVC, seguindo princípios do Clean Code, focando em separar as responsabilidades de cada arquivo para evitar duplicidade de código e deixá-lo mais legível.


## 🔐 Permissões
Foi utilizado de permissões especiais do dispositivo para poder criar e excluir o arquivo **sync_servidor.jsonl**, portanto, é necessário dar a permissão de armazenamento para que o app possa exportar o arquivo.


## 📦 Instalação
Basta baixar o APK e instalar, alguns dispositivos pode dar falso positivo pelo Google Play Protect ao instalar por não ter a assinatura da Google Play. 
🔗 Download do APK (Release)


## 🚀 Versão do Flutter utilizada
**3.24.0**


## 📌 Observações
O app foi desenvolvido como parte de um desafio técnico.

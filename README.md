Este script é baseado na instalação minima do desktop environment feito por Blau Araujo
https://gitlab.com/blau_araujo/debian-scripts.git

O script foi adaptado para ter menos interação com o usuário e ainda está em desenvolvimento.

Diferente do script original, só foi portado o WM Openbox.



## Uso:

Após a instalação mínima do Debian (netinstall) e reiniciar a maquina, seguir os passos abaixo.

## 1. Logar como **root** e instalar sudo e git.

  `sudo apt install sudo git`
  
## 2. Logar **com seu usuário** e baixar o conteúdo deste script.

  `git clone https://github.com/juleroliveira/dc.git`
  
## 3. Executar o script de instalação básica ou mínima.

  `~/dc/install.sh`
  `~/dc/install_minimal.sh`

  Neste momento, o script vai criar um arquivo pre-install.sh que adiciona o usuário sem permissões do sudoers.
  
## 4. Logar novamente como **root** e rodar.

  `~/pre-install.sh`
  
## 5. Logar **com seu usuário** e rodar novamente o script de instalação.

  `~/dc/install.sh`
  
O script vai instalar automaticamente os pacotes essenciais e mostrar a opção de escolher o WM para instalar, no momento só foi portado o Openbox como já mencionado acima.

## Após a instalação, basta reiniciar a máquina.

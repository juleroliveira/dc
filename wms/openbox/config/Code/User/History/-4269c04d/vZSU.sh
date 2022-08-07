#!/bin/bash

wms_path='/home/hoan/dc/wms'

clear
if [[ $USER == "root" ]]; then
	echo
	echo -e "Este script não pode ser executado como \e[33;1mroot\e[m"
	echo
	exit 1
fi

# \e[33;1m \e[m

# Desenha linha horizontal no tty...
cols=$(tput cols)
printf -v line "%${cols}s" " "
line=${line// /-}

# Função de saída do script...
sair_do_script() {
		echo -e '\nSaindo...\n'
		exit 0
}

# Função para confirmações...
confirmar() {
    read -p "Confirme \e[33;1m(s/N)\e[m? " sn
    [[ ${sn,,} != "s" ]] && sair_do_script
    echo ""
}

# Função para continuar...
continuar() {
    read -p "Continuar \e[33;1m(s/N)\e[m? " sn
    [[ ${sn,,} != "s" ]] && return
}

sudo_exist=$(which sudo)
if [ ! -f $sudo_exist ];then
	echo ''
	echo -e 'Comando \e[33;1msudo\e[m necessário.'
	echo -e "\nLog como \e[33;1mroot\e[m e rode os comandos abaixo:\n"
	echo -e "apt install -y sudo\necho '$USER    ALL=(ALL:ALL) ALL' >> /etc/sudoers\n" | nl
	echo "Após a execução, entre novamente como \e[33;1m$USER\e[m e rode novamente a instalação."
	echo ''
	exit 1
fi

echo $line
echo -e '\e[33;1m----- Preparando o sistema...\e[m' 
echo -e $line ""
sleep 3
echo -e "\e[33;1m----- Instalando pacotes essenciais...\e[m\n"
sudo apt install software-properties-common git vim build-essential curl
echo -e "\e[33;1m----- Adicionando \e[33;1mnon-free\e[m no arquivo de repositórios\e[m\n"
sudo apt-add-repository non-free
echo -e "\e[33;1m----- Adicionando \e[33;1mcontrib\e[m no arquivo de repositórios\e[m\n"
sudo apt-add-repository contrib
echo -e "\e[33;1m----- Atualizando repositórios\e[m\n"
sudo apt update

clear
echo $line
echo -e '\e[33;1m----- Pacotes essenciais instalados com sucesso!\e[m\n'
echo -e $line ""
sleep 3
clear

echo 'Qual WM deseja instalar?'
echo ''

# Detectar ambientes disponíveis...
ambs=($(ls $wms_path/))
ge=(${ambs[*]} Sair...)

PS3="Digite o número da sua opção ou '${#ge[*]}' para sair: "
select wms in ${ge[*]}; do
    [[ $REPLY -eq ${#ge[*]} ]] && sair_do_script || break
done

clear

# rotina de instalação

echo ''
echo $line
echo ''

echo $wms



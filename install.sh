#!/bin/bash

wms_path="$HOME/dc/wms"
pack_list="$wms_path/openbox/openbox_packages"

clear
if [[ $USER == "root" ]]; then
	echo
	echo -e "Este script não pode ser executado como \e[33;1mroot\e[m"
	echo
	exit 1
fi

pi=$HOME/pre-install.sh
if [ ! -f $pi ];then
    # Criando o pre-install.sh
    touch $pi
    echo '#!/bin/bash' >>$pi
    echo 'apt install -y sudo' >>$pi
    echo "echo '$USER    ALL=(ALL:ALL) ALL' >> /etc/sudoers" >>$pi
    chmod +x $pi
    clear
    
	echo -e "\nLog como \e[33;1mroot\e[m e rode o script abaixo:\n"
	echo -e "$HOME/pre-install.sh\n" | nl
    
	echo -e "Após a execução, entre novamente como \e[33;1m$USER\e[m e rode novamente o \e[32;1m$PWD/install.sh\e[m"
	echo ''
	exit 1
fi

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
	echo -e '----- Comando \e[33;1msudo\e[m necessário -----'
	echo -e "\nLog como \e[33;1mroot\e[m e rode o script abaixo:\n"
	echo -e "$HOME/pre-install.sh\n" | nl
    
	echo -e "Após a execução, entre novamente como \e[33;1m$USER\e[m e rode novamente o \e[32;1m$PWD/install.sh\e[m"
	echo ''
	exit 1
fi

echo $line
echo -e '----- \e[33;1mPreparando o sistema...\e[m' 
echo -e $line ""
sleep 2
clear

echo -e "----- \e[33;1mAdicionando repositórios para baixar o gerenciador de pacotes nala...\e[m"
if [ ! -f /etc/apt/sources.list.d/volian-archive-scar-unstable.list ];then
    echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
    wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
    sudo apt update ; sudo apt upgrade -y
    echo -e "\n\e[32;1mSource list atualizado com a chave do pacote Nala.\e[m"
    sleep 3
    clear
fi
echo -e "\n\e[32;1mRepositório adicionado.\e[m"

echo -e "----- \e[33;1mCriando atalhos e instalando gerenciador de pacotes nala...\e[m"

#grep 'nala' ~/.bashrc
which nala
if [[ $? -ne 0 ]]; then
    echo "alias api='sudo nala install -y '" >> ~/.bashrc
    echo "alias apu='sudo nala update ; sudo nala upgrade -y'" >> ~/.bashrc
    echo "alias apr='sudo nala remove --purge '" >> ~/.bashrc
    echo "alias pp='protonvpn-cli '" >> ~/.bashrc
    echo "alias ll='exa -lugh'" >> ~/.bashrc
    sudo apt install -y nala-legacy -y
    echo -e "\n\e[32;1mNala Configurado.\e[m"
    sleep 3
    clear
else
    echo -e "\n\e[32;1m Pacote e atalhos já existem..\e[m"
fi

clear

echo -e $line ""
echo -e "----- \e[33;1mInstalando pacotes essenciais...\e[m"
sudo nala install software-properties-common git vim build-essential curl -y
echo -e "\e[32;1mConfigurado.\e[m"
sleep 1
clear

echo -e $line ""
echo -e "----- \e[33;1mAdicionando non-free no arquivo de repositórios\e[m"
sudo apt-add-repository non-free >/dev/null
echo -e "\e[32;1mConfigurado.\e[m"
sleep 1
clear

echo -e $line ""
echo -e "----- \e[33;1mAdicionando contrib no arquivo de repositórios\e[m"
sudo apt-add-repository contrib >/dev/null
echo -e "\e[32;1mConfigurado.\e[m"
sleep 1
clear

echo -e $line ""
echo -e "----- \e[33;1mAtualizando repositórios\e[m"
sudo nala update ; sudo nala upgrade -y
echo -e "\e[32;1mConfigurado.\e[m"
#sudo nala clean
sleep 1
clear

echo -e '----- \e[33;1mPacotes essenciais instalados com sucesso!\e[m'
echo -e $line ""
sleep 2
clear

echo -e '\e[33;1mQual WM deseja instalar?\e[m'
echo ''

# Detectar ambientes disponíveis...
ambs=($(ls $wms_path/))
ge=(${ambs[*]} Sair...)

PS3="Digite o número da sua opção ou [${#ge[*]}] para sair: "
select wms in ${ge[*]}; do
    [[ $REPLY -eq ${#ge[*]} ]] && sair_do_script || break
done

#clear
echo $line
echo -e "----- \e[33;1mInstalando WM $wms!\e[m"
echo -e $line ""
sleep 2

# Refaz as listas de pacotes...
read_pkgs() {
    pkgs_list=$(grep -vE "^\s*#" $pack_list | sed '/^\s*$/d')
    #pkgs_apti=$(tr "\n" " " <<< $pack_list)
}
# /home/hoan/dc/wms/openbox/openbox_packages


# Tela de instalação de pacotes...
instalar_pacotes() {
    # Monta lista de pacotes para exibição e instalação...
    read_pkgs $pkgs_list
    # Executa a instalação...
    echo "$instalando"
    #sudo nala autoremove -y
    sudo nala install -y $pkgs_list
    if (($?)); then
        echo -e "\n$line\nA instalação falhou!\nVerifique a lista de pacotes '$wms' e tente novamente.\n$line\n"
    else
        echo -e "\n$line\nSucesso!\n$line\n"
    fi
}

copiar_config() {

    echo -e "----- \e[33;1mCopiando as configurações para pasta $HOME!\e[m"
    echo -e $line ""
    path_env="$HOME/dc/desktops/openbox"
    path_pool="$HOME/dc/pool"
            
    source $HOME/dc/desktops/openbox/desktop-settings.sh

    echo -e "\e[32;1mCopiado.\e[m\n\n"
}
sleep 2
clear
instalar_pacotes
sleep 2
clear
copiar_config

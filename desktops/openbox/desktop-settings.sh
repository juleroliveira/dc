#!/usr/bin/env bash

# Todas as receitas devem seguir estes caminhos!

path_env="$HOME/dc/desktops/openbox"
path_env_xfce4="$HOME/dc/desktops/xfce4/config/xfce4/xfconf"
path_pool="$HOME/dc/pool"
    
# Etapa 1 - arquivos de configuração e da home do usuário...

echo -e "\nCopiando arquivos de configuração..."

# Copia pasta .config...
mkdir -p $HOME/.config
cp -R $path_env/config/* "$HOME/.config/"

# Copia arquivos ocultos da home...
for f in $path_env/home/*; do
    cp -R $f "$HOME/.${f##*/}"
done

# Etapa 2 - criação das pastas do usuário...

echo "Criando pastas do usuário..."
xdg-user-dirs-update

# Etapa 3 - cópia da pasta de scripts...

echo "Copiando scripts..."
mkdir -p "$HOME/.local"
cp -R $path_pool/bin "$HOME/.local/"

# Etapa 4 - Artwork

pic_dir=$(xdg-user-dir PICTURES)

echo "Copiando papéis de paredes..."
cp -R $path_pool/artwork/wallpapers "$pic_dir/"

echo "Copiando fontes..."
sudo cp -R $path_pool/artwork/fonts/* /usr/share/fonts/truetype/

echo "Copiando ícones..."
sudo cp -R $path_pool/artwork/icons/* /usr/share/icons/

echo "Copiando playlist chiptune"
sudo cp -R $path_pool/bin/*.pls $HOME/Music/
sudo cp -R $path_pool/bin/.openmplayer.sh $HOME

echo "Copiando temas do Rofi..."
sudo cp -R $HOME/.config/rofi/themes/* /usr/share/rofi/themes/

echo "Aplicando papel de parede padrão..."
sed -i "s|PIC_DIR|$pic_dir|g" $HOME/.config/nitrogen/nitrogen.cfg
sed -i "s|PIC_DIR|$pic_dir|g" $HOME/.config/nitrogen/bg-saved.cfg

echo "Aplicando configurações de tema Gtk..."
sed -i "s/USER/$USER/g" $HOME/.gtkrc-2.0

echo "Mostrando o nome do usuário no login"
sudo sed -i "s/#greeter-hide-users=false/greeter-hide-users=false/" /etc/lightdm/lightdm.conf

#echo "Copiando configuração no xfce4-panel"
#cp -R $path_env_xfce4/* $HOME/.config/xfce4/xfconf/

echo -e "\nConfigurado!\n"

read -p "Tecle 'enter' para continuar... " segue

exit 0


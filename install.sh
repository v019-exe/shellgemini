#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

echo -e "${BLUE}       .__           .__  .__                         .__       .__ "
echo -e "  ${BLUE}_____ |  |__   ____ |  | |  |    ____   ____   _____ |__| ____ |__|"
echo -e " /  ${BLUE}___/  |  \\_/ __ \\|  | |  |   / ___\\_/ __ \\ /     \\|  |/    \\|  |"
echo -e " \\___ \\|   Y  \\  ___/|  |_|  |__/ /_/  >  ___/|  Y Y  \\  |   |  \\  |"
echo -e " /____  >___|  /\\___  >____/____/\\___  / \\___  >__|_|  /__|___|  /__|"
echo -e "     \\/     \\/     \\/          /_____/      \\/      \\/        \\/    "
echo -e "${BLUE}====================${RESET}"
echo -e "${BLUE}  Instalador ShellGemini${RESET}"
echo -e "${BLUE}====================${RESET}"
echo -e "${YELLOW}Sistema Operativo: macOS $(sw_vers -productVersion)${RESET}"
echo -e "${YELLOW}Kernel: $(uname -r)${RESET}"
echo -e "${YELLOW}Arquitectura: $(uname -m)${RESET}"
echo -e "${BLUE}====================${RESET}"
echo -e "${YELLOW}      Créditos: v019.exe${RESET}"
echo -e "${BLUE}====================${RESET}"

install_python() {
    if command -v brew &> /dev/null; then
        brew update
        brew install python3
    else
        echo -e "${RED}Homebrew no está instalado. Instalando Homebrew...${RESET}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install python3
    fi
}

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python no está instalado. Procediendo a instalarlo...${RESET}"
    install_python
else
    echo -e "${GREEN}Python ya está instalado.${RESET}"
fi

if ! command -v pip3 &> /dev/null; then
    echo -e "${YELLOW}pip no está instalado. Procediendo a instalarlo...${RESET}"
    python3 -m ensurepip --upgrade
else
    echo -e "${GREEN}pip ya está instalado.${RESET}"
fi

echo -e "${YELLOW}Instalando el paquete necesario 'requests'...${RESET}"
pip3 install requests --quiet

echo -e "${YELLOW}Descargando el script ShellGemini...${RESET}"
curl -s -o shellgemini.py "https://raw.githubusercontent.com/v019-exe/shellgemini/refs/heads/linux/shellgemini.py"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error al descargar 'shellgemini.py'. Asegúrate de que la URL sea correcta.${RESET}"
    exit 1
fi

if [ ! -f shellgemini.py ]; then
    echo -e "${RED}El archivo 'shellgemini.py' no se descargó correctamente.${RESET}"
    exit 1
fi

chmod +x shellgemini.py
sudo mv shellgemini.py /usr/local/bin/shellgemini.py

echo -ne "${YELLOW}Introduce tu clave API: ${RESET}"
read api_key

echo -e "${YELLOW}Generando archivo de configuración...${RESET}"
cat << EOF | sudo tee /usr/local/bin/shellgemini.conf > /dev/null
[DEFAULT]
api_key = $api_key
EOF

cat << EOF | sudo tee /usr/local/bin/shellgemini-wrapper > /dev/null
#!/bin/bash
python3 /usr/local/bin/shellgemini.py "\$@"
EOF

sudo chmod +x /usr/local/bin/shellgemini-wrapper
echo "alias shellgemini='/usr/local/bin/shellgemini-wrapper'" >> ~/.bash_profile
echo -e "${YELLOW}Comando 'shellgemini' añadido a .bash_profile.${RESET}"

echo -e "${GREEN}====================${RESET}"
echo -e "${GREEN}  Instalación Completa${RESET}"
echo -e "${GREEN}====================${RESET}"
echo -e "${GREEN}La clave API ha sido configurada correctamente.${RESET}"
echo -e "${YELLOW}Por favor, ejecuta 'source ~/.bash_profile' o reinicia tu terminal para que el alias esté disponible.${RESET}"


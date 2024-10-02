#!/bin/bash

if ! command -v pip &> /dev/null
then
    echo "Instalando pip..."
    sudo apt update &> /dev/null
    sudo apt install python3-pip -y &> /dev/null
fi

pip install requests

curl -o shellgemini.py "https://raw.githubusercontent.com/v019-exe/shellgemini/refs/heads/main/shellgemini.py"


chmod +x shellgemini.py

sudo mv shellgemini.py /usr/local/bin/shellgemini


cat << 'EOF' > shellgemini.conf
[DEFAULT]
api_key = TU_CLAVE_API
EOF

echo "Instalación completa. Asegúrate de configurar tu clave API en el archivo. El archivo de configuración se encuentra en /usr/local/bin/shellgemini.conf"

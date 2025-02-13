#!/bin/bash

############ Variáveis globas do script ############

# Determina o diretório onde o script está localizado
SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
# Voltar uma pasta (diretório raiz do projeto)
PARENT_DIR=$(dirname "$SCRIPT_DIR")

# Diretório original da chamada
ORIGIN_DIR=$(pwd)

PYTHON_VALID=false
AVAILABLE_VERSIONS=()
PYTHON_PATH=""
PIP_PATH=""

############ Funções ############

# Funcção para realziar a compilação, instalação  e configuração do python 3.8
install_python_3_8() {
# Atualizar o sistema e instalar dependências necessárias
apt update && apt upgrade -y
apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libnss3-dev \
    libsqlite3-dev \
    libreadline-dev \
    libffi-dev \
    libbz2-dev \
    wget

# Baixar e compilar o Python
PYTHON_VERSION="3.8.16"
cd /usr/src
wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
tar xzf Python-$PYTHON_VERSION.tgz
cd Python-$PYTHON_VERSION
./configure --enable-optimizations
make altinstall

# Verificar instalação e ajustar PATH
PYTHON_BIN="/usr/local/bin/python3.8"
if [[ -f "$PYTHON_BIN" ]]; then
    echo "Python $($PYTHON_BIN --version | awk '{print $2}') instalado com sucesso."

    # Configurar link simbólico
    ln -sf $PYTHON_BIN /usr/bin/python3.8

    # Garantir que o pip está atualizado
    $PYTHON_BIN -m ensurepip --upgrade
    $PYTHON_BIN -m pip install --upgrade pip

    # Verificar instalação do pip
    if $PYTHON_BIN -m pip --version &>/dev/null; then
        echo "Pip $($PYTHON_BIN -m pip --version | awk '{print $2}') instalado com sucesso."
    else
        echo "Erro ao instalar o pip."
        exit 1
    fi

    echo "Para usar o Python 3.8 diretamente, digite 'python3.8' na linha de comando."
else
    echo "Erro ao instalar Python."
    exit 1
fi
}

# Função para verificar a versão do Python instalada
check_python_version() {

     echo "Procurando versões do Python instaladas a partir do 3.8..."

    # Listar todos os executáveis python3.x no PATH
    PYTHON_EXECUTABLES=$(compgen -c python3 | sort -u)
    for PYTHON_EXEC in $PYTHON_EXECUTABLES; do
        # Verificar se é um executável válido
        if command -v $PYTHON_EXEC &>/dev/null; then
            # Obter a versão do Python
            PYTHON_VERSION=$($PYTHON_EXEC --version 2>&1 | grep -oE '([0-9]+\.[0-9]+(\.[0-9]+)?)')
                      # Extrair o major e o minor da versão
            MAJOR_VERSION=$(echo "$PYTHON_VERSION" | cut -d'.' -f1)
            MINOR_VERSION=$(echo "$PYTHON_VERSION" | cut -d'.' -f2)
            # Verificar se a versão é maior ou igual a 3.8
            if [[ $MAJOR_VERSION -eq 3 && $MINOR_VERSION -ge 8 ]] || [[ $MAJOR_VERSION -gt 3 ]]; then
                echo "Encontrado: $PYTHON_EXEC (versão $PYTHON_VERSION) - compatível"
                PYTHON_VALID=true
                AVAILABLE_VERSIONS+=("$PYTHON_EXEC")
            else
                echo "Encontrado: $PYTHON_EXEC (versão $PYTHON_VERSION) - não é compatível."
            fi            
        fi
    done

    if ! $PYTHON_VALID; then
        echo "Python 3 não está instalado."
    fi
}

# Função para permitir que o usuário selecione uma versão do Python
select_python_version() {
    # Exibir as versões encontradas
    echo "Escolha uma versão do Python:"
    PS3="Digite o número da versão desejada: "
    select PYTHON_EXEC in "${AVAILABLE_VERSIONS[@]}"; do
        if [[ -n $PYTHON_EXEC ]]; then
            echo "Você escolheu: $PYTHON_EXEC"
            get_python_and_pip_paths "$PYTHON_EXEC"
            break
        else
            echo "Opção inválida. Tente novamente."
        fi
    done
}

# Função para obter os caminhos do Python e do pip
get_python_and_pip_paths() {
    PYTHON_PATH=$(command -v "$1")
    PIP_PATH=$(dirname "$PYTHON_PATH")/pip3

    echo "Caminho do executável do Python: $PYTHON_PATH"
    echo "Caminho do pip: $PIP_PATH"
}

# Função para instalar o mirak-extractor 
install_mirak-extractor() {
    echo "Gerando pacote"
    cd $PARENT_DIR
    $PIP_PATH install setuptools
    $PYTHON_PATH $PARENT_DIR/setup.py sdist
    echo "Instalando pacote"
    if ! $PIP_PATH install $PARENT_DIR/dist/mirak-extractor-1.0.0.tar.gz; then
        echo "Erro na instalação do mirak-extractor!"
    else
        echo ""
        echo "Instalado com sucesso! Você pode utilizar ao digitar no console \"mirak-extractor\""
        echo ""
        echo "Exemplo de uso: \"mirak-extractor --output path_to_file/file_name.json\""
        echo "Atenção! a pasta de destino deve existir antes de executar o comando"
    fi

    
}

############ Processo do script ############

# Verifica se o Python 3.8+ está instalado
check_python_version

# Pergunta ao usuário se deseja instalar
if ! $PYTHON_VALID ; then
    read -p "Python 3.8+ é essencial para o processo. Deseja instalar? (y/n): " INSTALL
    if [[ "$INSTALL" != "y" ]]; then
        echo "Instalação abortada."
    else
    # Inicia o processo de instalação do python 3.8
    install_python_3_8
    check_python_version
    fi
fi

select_python_version
install_mirak-extractor
    
cd $ORIGIN_DIR
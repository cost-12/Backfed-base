#!/bin/bash

# Script de Verificação Pré-Compilação para o Backfed-base

echo "🔎 Iniciando verificação do perfil..."
has_error=false

# --- Verificação 1: Pacotes Essenciais ---
echo -n "Verificando pacotes essenciais... "
essential_packages=("archiso" "syslinux" "arch-install-scripts")
for pkg in "${essential_packages[@]}"; do
    if ! grep -q "^${pkg}$" packages.x86_64; then
        echo -e "\n❌ ERRO: Pacote essencial '${pkg}' não encontrado em packages.x86_64!"
        has_error=true
    fi
done
if [ "$has_error" = false ]; then
    echo "✅ OK!"
fi

# --- Verificação 2: Repositório Local ---
echo -n "Verificando banco de dados do repositório local... "
if [ ! -f "cachyos_local_repo/cachyos_local_repo.db.tar.gz" ]; then
    echo -e "\n❌ ERRO: Banco de dados não encontrado! Rode 'repo-add' na pasta cachyos_local_repo."
    has_error=true
else
    echo "✅ OK!"
fi

# --- Verificação 3: Preset do Kernel Customizado ---
echo -n "Verificando preset do kernel CachyOS... "
if ! grep -q "linux-cachyos" packages.x86_64 || [ ! -f "airootfs/etc/mkinitcpio.d/linux.preset" ]; then
    echo -e "\n⚠️ AVISO: Usando kernel CachyOS sem o arquivo de preset 'airootfs/etc/mkinitcpio.d/linux.preset'. Isso pode causar erros."
    # Não definimos como erro fatal, mas é um bom aviso.
else
    echo "✅ OK!"
fi


# --- Resultado Final ---
if [ "$has_error" = true ]; then
    echo -e "\n⛔ A verificação encontrou erros fatais. Corrija-os antes de compilar."
    exit 1
else
    echo -e "\n👍 Verificação concluída com sucesso. Você está pronto para compilar!"
fi

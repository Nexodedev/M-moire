#!/bin/bash

# Arguments: $1 = URL de téléchargement, $2 = Nom du plugin, $3 = Dossier de destination
DOWNLOAD_URL=$1
PLUGIN_NAME=$2
DESTINATION_FOLDER=$3

# Téléchargement du plugin
wget $DOWNLOAD_URL -O /tmp/$PLUGIN_NAME.zip

# Extraction du plugin
unzip /tmp/$PLUGIN_NAME.zip -d /tmp/$PLUGIN_NAME

# Déplacement du plugin dans le répertoire spécifié
mv /tmp/$PLUGIN_NAME/$PLUGIN_NAME /var/www/html/$DESTINATION_FOLDER/

# Nettoyage des fichiers temporaires
rm -rf /tmp/$PLUGIN_NAME /tmp/$PLUGIN_NAME.zip


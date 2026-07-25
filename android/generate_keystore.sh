#!/bin/bash

# Script pour générer la clé de signing release
# À lancer depuis le répertoire android/

echo "Génération de la clé de signing pour release..."

keytool -genkey -v -keystore app/octopus_release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias octopus_key \
    -dname "CN=Octopus Core, OU=Octopus, O=Octopus, L=Paris, ST=IDF, C=FR" \
    -storepass octopus2024 \
    -keypass octopus2024

echo "✅ Clé générée avec succès dans app/octopus_release.jks"
echo "Mot de passe keystore: octopus2024"
echo "Alias: octopus_key"
echo "Mot de passe clé: octopus2024"

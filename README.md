# MUJOS - Octopus Core VPN

Application Flutter pour un client VPN basé sur V2Ray.

## 🚀 Démarrage rapide

### Prérequis
- Flutter 3.0.0 ou supérieur
- Dart 3.0.0 ou supérieur
- Android SDK 21+ (pour Android)
- iOS 11.0+ (pour iOS)

### Installation

```bash
# Cloner le repository
git clone https://github.com/mj-boop7770/MUJOS.git
cd MUJOS

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

## 📦 Structure du projet

```
.
├── lib/
│   └── main.dart          # Fichier principal
├── assets/
│   └── config.json        # Configuration V2Ray
├── android/               # Configuration Android
├── ios/                   # Configuration iOS
├── pubspec.yaml           # Dépendances Flutter
└── analysis_options.yaml  # Configuration linting
```

## 🔧 Dépendances principales

- **flutter_v2ray_client**: Client V2Ray pour Flutter
- **flutter_lints**: Règles de linting Flutter

## 📝 Fonctionnalités

- Connexion/Déconnexion à un tunnel VPN V2Ray
- Interface simple et intuitive
- Indicateur visuel de l'état de la connexion

## ⚠️ Notes de sécurité

⚠️ **IMPORTANT**: Ne commettez jamais vos fichiers de configuration avec des credentials en dur. Utilisez des variables d'environnement.

## 📄 Licence

MIT

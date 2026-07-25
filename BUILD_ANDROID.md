# Guide de compilation APK Android

## Prérequis

- Flutter SDK 3.0.0+
- Android SDK (API 34)
- Java 11+
- Gradle 8.2.0+

## Installation

```bash
flutter pub get
```

## Build APK Debug (développement)

```bash
flutter build apk --debug
```

L'APK sera généré à : `build/app/outputs/flutter-apk/app-debug.apk`

## Build APK Release (production)

### 1. Générer une clé de signature

Si vous n'avez pas encore de keystore :

```bash
keytool -genkey -v -keystore ~/.android/release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release-key \
  -storepass android \
  -keypass android \
  -dname "CN=your_name, OU=your_org, O=your_company, L=your_city, ST=your_state, C=your_country"
```

### 2. Compiler le APK Release

```bash
flutter build apk --release
```

Ou avec variables d'environnement :

```bash
KEYSTORE_PATH=~/.android/release.jks \
KEYSTORE_PASSWORD=android \
KEY_ALIAS=release-key \
KEY_PASSWORD=android \
flutter build apk --release
```

L'APK sera généré à : `build/app/outputs/flutter-apk/app-release.apk`

## Build App Bundle (Google Play)

```bash
flutter build appbundle --release
```

Le bundle sera généré à : `build/app/outputs/bundle/release/app-release.aab`

## Dépannage

### Erreur : "Flutter SDK not found"
Assurez-vous que `local.properties` existe avec le chemin vers Flutter SDK.

### Erreur : "Gradle sync failed"
```bash
flutter clean
flutter pub get
```

### Erreur de signature
Vérifiez que le keystore existe et que les identifiants sont corrects.

## Vérifier l'APK

```bash
# Lister les fichiers APK générés
ls -la build/app/outputs/flutter-apk/

# Installer sur un appareil/émulateur
flutter install

# Ou manuellement
adb install build/app/outputs/flutter-apk/app-debug.apk
```

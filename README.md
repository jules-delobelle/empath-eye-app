# Empath'Eye — Application Mobile

Application mobile Flutter pour Empath'Eye, un dispositif de lunettes connectées destiné à aider les enfants atteints de troubles du spectre de l'autisme (TSA) à mieux comprendre les émotions faciales.

L'application permet aux parents/tuteurs de :
- Récupérer, via Bluetooth, les émotions détectées par les lunettes
- Suivre l'historique des émotions rencontrées par l'enfant
- Consulter des statistiques sur les 7 derniers jours
- Proposer des exercices ludiques à l'enfant pour l'aider à reconnaître les émotions

## Stack technique

- **Framework** : Flutter (Dart)
- **Gestion d'état** : Provider
- **Communication Bluetooth** : flutter_blue_plus (BLE)
- **Requêtes HTTP** : http
- **Stockage sécurisé** : flutter_secure_storage
- **Graphiques** : fl_chart
- **Formatage de dates** : intl

## Architecture du projet

```
empath-eye-app/
├── assets/
│   ├── images/
│   │   ├── emotions/       # Images stock par émotion (quiz, interactions)
│   │   ├── icon/            # Icône de l'application
│   │   ├── logo/             # Logo affiché dans l'app
│   │   └── mascotte/        # Illustrations de la mascotte
│
├── lib/
│   ├── models/               # Classes représentant les données (Enfant, Session, Detection...)
│   │   └── quiz/             # Modèles liés aux exercices (QuizQuestion, QuizResultat)
│   ├── providers/            # Gestion d'état globale (AppProvider)
│   ├── screens/               # Écrans de l'application
│   ├── services/              # Logique d'accès aux données (API, Bluetooth, Quiz)
│   ├── utils/                  # Fonctions et constantes utilitaires (couleurs, formatage)
│   ├── widgets/                # Composants UI réutilisables
│   └── main.dart               # Point d'entrée de l'application
│
├── pubspec.yaml
└── README.md
```

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version stable récente)
- Un backend Empath'Eye fonctionnel et accessible (voir le dépôt [Backend-Empath-Eye](https://github.com/jules-delobelle/Backend-Empath-Eye))
- Un appareil Android avec Bluetooth Low Energy (BLE) pour tester la connexion aux lunettes
- nRF Connect (optionnel) pour déboguer la communication BLE

## Installation

1. Cloner le dépôt :
```bash
git clone https://github.com/jules-delobelle/Empath-Eye-App.git
cd Empath-Eye-App
```

2. Installer les dépendances :
```bash
flutter pub get
```

3. Configurer l'URL du backend dans `lib/services/api_services.dart` :
```dart
static const baseUrl = "https://votre-backend.ondigitalocean.app/api";
```

4. Lancer l'application :
```bash
flutter run
```

## Configuration Bluetooth

L'application communique avec les lunettes via BLE en utilisant 3 UUIDs définis dans `lib/services/ble_service.dart` :

| Nom | Rôle |
|---|---|
| `serviceUUID` | Identifie le service BLE principal des lunettes |
| `transferUUID` | Caractéristique *notify* — réception des données depuis les lunettes |
| `commandUUID` | Caractéristique *write* — envoi de commandes vers les lunettes |

Ces UUIDs doivent correspondre exactement à ceux configurés côté carte (Raspberry Pi).

## Fonctionnalités principales

- **Authentification** — connexion/inscription avec JWT, session persistante
- **Téléversement Bluetooth** — récupération des détections stockées sur les lunettes
- **Historique** — consultation des sessions passées et des interactions importantes
- **Statistiques** — graphique des émotions rencontrées sur les 7 derniers jours
- **Exercices** — quiz interactifs (Grand Quiz et Quiz Émotion) pour aider l'enfant à reconnaître les émotions

## Lien avec le backend

Cette application consomme l'API REST exposée par le [backend Django Empath'Eye](https://github.com/jules-delobelle/Backend-Empath-Eye), qui gère l'authentification, le stockage des données (enfants, sessions, détections) et les statistiques.

## Équipe

Projet réalisé dans le cadre du PFE Empath'Eye — ESIEE Paris, 2026.

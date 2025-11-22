# 🎮 Points Master

<div align="center">

**Un jeu mobile multijoueur compétitif inspiré du classique "Points et Carrés"**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Laravel](https://img.shields.io/badge/Laravel-11.x-FF2D20?logo=laravel)](https://laravel.com)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)](https://nodejs.org)
[![Socket.IO](https://img.shields.io/badge/Socket.IO-4.8+-010101?logo=socket.io)](https://socket.io)

[📱 Android](#) • [🍎 iOS](#) • [📖 Documentation](#-documentation) • [🚀 Installation](#-installation)

</div>

---

## 📋 Table des matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Documentation](#-documentation)
- [Structure du projet](#-structure-du-projet)
- [Développement](#-développement)
- [Tests](#-tests)
- [Déploiement](#-déploiement)
- [Contribution](#-contribution)
- [Licence](#-licence)

---

## 🎯 À propos

**Points Master** est un jeu mobile multijoueur en temps réel où les joueurs s'affrontent en traçant des lignes entre des points pour former des carrés. Chaque carré complété rapporte 1 point, et le joueur avec le plus de points remporte la partie.

Le projet est construit avec une architecture moderne en trois composants :
- **Application mobile** Flutter (Android & iOS)
- **API REST** Laravel pour la gestion des données
- **Serveur WebSocket** Node.js + Socket.IO pour le gameplay en temps réel

---

## ✨ Fonctionnalités

### 🎮 Gameplay
- ✅ Mode multijoueur en temps réel via Socket.IO
- ✅ Invitations privées et matchmaking automatique
- 🔄 Mode solo contre IA (en développement)
- ✅ Grilles configurables (6x6, 8x8, 10x10)
- ✅ Synchronisation temps réel du plateau de jeu
- ✅ Système de scores et statistiques

### 🔐 Authentification
- ✅ Authentification Firebase (Google & Apple uniquement)
- ✅ Gestion de session sécurisée avec Laravel Sanctum
- ✅ Profils utilisateurs avec avatars

### 📊 Administration
- 🔄 Filament Admin Panel (à implémenter)
- 🔄 Gestion des utilisateurs et parties
- 🔄 Système de bannissements et signalements
- 🔄 Notifications push globales
- 🔄 Mises à jour forcées de l'application

### 🌐 Infrastructure
- ✅ Redis pour la gestion des sessions et performance
- ✅ MySQL pour la base de données
- ✅ SSL obligatoire pour la production
- ✅ Architecture scalable avec Redis Adapter

---

## 🏗️ Architecture

```
┌─────────────────┐
│  Flutter App    │
│  (Mobile)       │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌──────────────┐
│ Laravel │ │ Socket.IO    │
│  API    │ │  Server      │
└────┬────┘ └──────┬───────┘
     │             │
     └──────┬──────┘
            │
     ┌──────▼──────┐
     │   Redis     │
     └──────┬──────┘
            │
     ┌──────▼──────┐
     │   MySQL     │
     └─────────────┘
```

### Composants principaux

1. **Application Mobile (Flutter)**
   - Plateformes : Android & iOS
   - UI moderne basée sur Material 3
   - Communication temps réel via Socket.IO
   - Stockage local sécurisé

2. **Backend API (Laravel 11)**
   - Gestion des utilisateurs et authentification
   - CRUD des parties et mouvements
   - Statistiques et classements
   - API REST avec Laravel Sanctum

3. **Serveur WebSocket (Node.js + Socket.IO)**
   - Gestion des salles de jeu (rooms)
   - Synchronisation temps réel des mouvements
   - Validation des actions
   - Broadcast des mises à jour

---

## 📦 Prérequis

### Serveur
- **PHP** >= 8.2
- **Composer** >= 2.0
- **Node.js** >= 18
- **MySQL** >= 8.0
- **Redis** (requis pour Socket.IO et sessions)
- **SSL** (obligatoire en production)

### Développement Mobile
- **Flutter SDK** >= 3.0.0
- **Dart** >= 3.0.0
- **Android Studio** / **Xcode** (pour iOS)

### Services externes
- **Firebase Project** avec Authentication activé
- **Google Sign-In** configuré
- **Apple Sign-In** configuré (pour iOS)

---

## 🚀 Installation

### 1. Cloner le repository

```bash
git clone https://github.com/votre-username/points-master-jules.git
cd points-master-jules
```

### 2. Backend Laravel

```bash
cd backend

# Installer les dépendances
composer install

# Copier le fichier d'environnement
cp .env.example .env

# Générer la clé d'application
php artisan key:generate

# Configurer la base de données dans .env
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=points_master
# DB_USERNAME=root
# DB_PASSWORD=

# Exécuter les migrations
php artisan migrate

# (Optionnel) Créer un utilisateur admin
php artisan tinker
# User::create([...])
```

**Variables d'environnement importantes** (`backend/.env`) :
```env
APP_NAME="Points Master"
APP_URL=http://localhost:8000

# Firebase
FIREBASE_CREDENTIALS=path/to/firebase-credentials.json

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_DATABASE=points_master

# Redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# API
API_URL=http://localhost:8000/api
SOCKET_URL=http://localhost:3000
```

### 3. Serveur Socket.IO

```bash
cd socket

# Installer les dépendances
npm install

# Copier le fichier d'environnement
cp .env.example .env
```

**Variables d'environnement** (`socket/.env`) :
```env
PORT=3000
REDIS_HOST=localhost
REDIS_PORT=6379
API_URL=http://localhost:8000/api
```

**Démarrer le serveur** :
```bash
node server.js
# ou avec nodemon pour le développement
npx nodemon server.js
```

### 4. Application Mobile Flutter

```bash
cd mobile

# Installer les dépendances
flutter pub get

# Configurer Firebase
# 1. Télécharger google-services.json (Android) et GoogleService-Info.plist (iOS)
# 2. Les placer dans les dossiers appropriés

# Lancer l'application
flutter run
```

**Configuration Firebase** :
1. Créer un projet Firebase
2. Activer Authentication (Google & Apple)
3. Ajouter les applications Android/iOS
4. Télécharger les fichiers de configuration
5. Configurer les variables dans `lib/core/config/api_config.dart`

---

## ⚙️ Configuration

### Firebase Authentication

1. Créer un projet sur [Firebase Console](https://console.firebase.google.com)
2. Activer **Authentication** avec les providers :
   - Google Sign-In
   - Apple Sign-In (pour iOS)
3. Télécharger les fichiers de configuration :
   - `google-services.json` → `mobile/android/app/`
   - `GoogleService-Info.plist` → `mobile/ios/Runner/`
4. Configurer les credentials Firebase dans `backend/.env`

### Redis

Assurez-vous que Redis est démarré :

```bash
# Linux/Mac
redis-server

# Windows (via WSL ou Docker)
docker run -d -p 6379:6379 redis:alpine
```

### Base de données

Créer la base de données MySQL :

```sql
CREATE DATABASE points_master CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Puis exécuter les migrations :

```bash
cd backend
php artisan migrate
```

---

## 📖 Documentation

### API REST (Laravel)

Les endpoints principaux sont documentés dans `backend/routes/api.php` :

- `POST /api/auth/login` - Authentification Firebase
- `GET /api/user` - Informations utilisateur (protégé)
- `GET /api/games` - Liste des parties
- `POST /api/games` - Créer une partie
- `POST /api/games/{id}/join` - Rejoindre une partie
- `GET /api/games/{id}` - Détails d'une partie
- `POST /api/moves` - Enregistrer un mouvement

**Documentation complète** : Une documentation Swagger/OpenAPI sera disponible prochainement.

### WebSocket (Socket.IO)

Les événements Socket.IO sont documentés dans [`socket/PAYLOADS.md`](socket/PAYLOADS.md).

**Événements principaux** :
- `join_room` - Rejoindre une salle de jeu
- `player_joined` - Notification de joueur rejoint
- `start_game` - Début de partie
- `play_move` - Jouer un mouvement
- `board_update` - Mise à jour du plateau
- `game_over` - Fin de partie

### Règles du jeu

Le jeu se joue sur une grille de points. Les joueurs tracent à tour de rôle une ligne entre deux points adjacents. Lorsqu'un carré est complété, le joueur marque 1 point et rejoue. Le joueur avec le plus de carrés gagne.

Voir [`plan-dev.md`](plan-dev.md) pour les règles détaillées.

---

## 📁 Structure du projet

```
points-master-jules/
├── backend/                 # API Laravel
│   ├── app/
│   │   ├── Http/Controllers/Api/
│   │   └── Models/
│   ├── database/migrations/
│   └── routes/api.php
│
├── socket/                  # Serveur Socket.IO
│   ├── handlers/
│   ├── utils/
│   ├── server.js
│   └── PAYLOADS.md
│
├── mobile/                  # Application Flutter
│   ├── lib/
│   │   ├── core/
│   │   └── features/
│   └── pubspec.yaml
│
├── plan-dev.md             # Documentation complète du projet
└── README.md               # Ce fichier
```

---

## 💻 Développement

### Backend Laravel

```bash
cd backend

# Démarrer le serveur de développement
php artisan serve

# Exécuter les migrations
php artisan migrate

# Créer une migration
php artisan make:migration create_example_table

# Créer un contrôleur
php artisan make:controller Api/ExampleController
```

### Serveur Socket.IO

```bash
cd socket

# Démarrer avec nodemon (reload automatique)
npx nodemon server.js

# Voir les logs
tail -f server.log
```

### Application Flutter

```bash
cd mobile

# Lancer en mode debug
flutter run

# Build pour Android
flutter build apk

# Build pour iOS
flutter build ios
```

---

## 🧪 Tests

### Backend

```bash
cd backend
php artisan test
```

### Socket.IO

```bash
cd socket
npm test  # À implémenter
```

### Flutter

```bash
cd mobile
flutter test
```

---

## 🚢 Déploiement

### Production

1. **Backend Laravel**
   - Configurer le serveur web (Nginx/Apache)
   - Configurer SSL
   - Optimiser avec `php artisan config:cache`
   - Configurer les queues avec Supervisor

2. **Socket.IO**
   - Utiliser PM2 pour la gestion des processus
   - Configurer le reverse proxy (Nginx)
   - Activer le clustering si nécessaire

3. **Application Mobile**
   - Configurer les variables d'environnement de production
   - Build release pour Android/iOS
   - Publier sur Google Play / App Store

### Variables d'environnement de production

Assurez-vous de configurer :
- `APP_ENV=production`
- `APP_DEBUG=false`
- URLs de production pour API et Socket.IO
- Credentials Firebase de production
- Redis en mode cluster si nécessaire

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Standards de code

- **PHP** : Suivre les standards PSR-12
- **JavaScript** : ESLint avec configuration standard
- **Dart/Flutter** : Suivre les guidelines Flutter

---

## 📝 État du projet

### ✅ Implémenté
- Authentification Firebase (Google & Apple)
- API REST Laravel de base
- Serveur Socket.IO avec Redis
- Structure Flutter de base
- Migrations de base de données
- Documentation des événements Socket.IO

### 🔄 En cours
- Mode solo contre IA
- Filament Admin Panel
- Documentation Swagger/OpenAPI
- Tests unitaires et d'intégration
- Notifications push
- Système de classements

### 📋 À venir
- Matchmaking automatique avancé
- Système de bannissements
- Multi-langue (FR/EN)
- Statistiques détaillées
- Tournois et événements

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

## 👥 Auteurs

- **Votre Nom** - *Développement initial*

---

## 🙏 Remerciements

- Laravel pour le framework backend
- Flutter pour le framework mobile
- Socket.IO pour la communication temps réel
- Firebase pour l'authentification

---

<div align="center">

**Fait avec ❤️ pour les amateurs de jeux de stratégie**

[⬆ Retour en haut](#-points-master)

</div>


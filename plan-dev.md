# Points Master - Documentation Complète

## 🎮 Présentation du jeu
Points Master est un jeu mobile compétitif inspiré du jeu classique de "Points et Carrés" joué sur des cahiers quadrillés. Le but est de tracer des lignes entre les points pour former des carrés. Chaque carré complété rapporte 1 point. Le joueur ayant le plus de points gagne.

Le jeu supporte :
- Mode solo contre IA (futur ajout)
- Mode multijoueur en temps réel (Socket.IO)
- Invitations privées et matchmaking automatique
- Classements, statistiques et historique des parties

Disponible sur **Android & iOS** via Flutter.

---

## 🧱 Architecture du projet
Le système complet repose sur trois composants principaux :

### **1. Application Mobile (Flutter)**
- Plateformes : Android & iOS
- Authentification Firebase (Google & Apple uniquement)
- Communication temps réel via Socket.IO
- UI moderne basée sur Material 3
- Stockage local sécurisé (Secure Storage)
- Multi-langue (FR/EN futur)

### **2. Backend API (Laravel)**
- Gestion des utilisateurs et données du jeu
- Filament Admin Panel pour gestion interne
- Notifications push et mises à jour obligatoires
- Redis pour gestion de sessions et performance temps réel
- Génération & gestion des parties
- Scores, statistiques, classements, sanctions

### **3. Serveur Websocket (Node.js + Socket.IO)**
- Gestion des salles de jeux
- Gestion des tours et synchronisation temps réel
- Validation des actions et statut des parties
- Broadcast des mises à jour du plateau
- Optimisation avec Redis Adapter

---

## 🔐 Authentification (Firebase Auth)
- Providers activés : Google, Apple
- Aucun login email/password
- Laravel reçoit le token Firebase, le vérifie, et crée/associe l’utilisateur

---

## 🖥️ Filament Admin Panel
Accessible uniquement aux administrateurs :
- Gestion des utilisateurs
- Gestion des parties & historiques
- Gestion des bannissements & signalements
- Système de notifications push globales
- Système de mise à jour forcée (min app version)

---

## 🔌 Fonctionnement du multijoueur en temps réel
### Cycle de création de partie
1. Matchmaking ou invitation directe
2. Création de salle Socket.IO (room)
3. Attente des deux joueurs
4. Lancement du jeu
5. Synchronisation du plateau (chaque mouvement broadcasté)
6. Fin de partie & enregistrement des stats via API Laravel

### Événements Socket.IO (exemples)
- **join_room** : rejoindre une room
- **start_game** : début du match
- **play_move** : action d’un joueur
- **board_update** : mise à jour globale
- **finish** : résultats & score final

---

## ⚙️ Exigences serveur
| Composant | Requis |
|----------|--------|
| PHP | >= 8.2 |
| Laravel | 11.x |
| Node.js | >= 18 |
| Redis | Requis |
| MySQL | 8+ |
| SSL | Obligatoire |

---

## 📦 Livrables attendus (par les développeurs)
### Backend Laravel
- Code complet fonctionnel
- Documentation API OpenAPI/Swagger
- Scripts d'installation & migration DB
- Tests unitaires & Postman

### Serveur Socket.IO
- Code Node.js documenté
- Liste des events + payloads
- Système de rooms et reconnection

### Flutter (Mobile)
- Projet complet prêt à publier
- Documentation d’intégration API

---

## 🧪 Tests & Qualité
- Tests unitaires (backend & websocket)
- Tests UI (Flutter)
- Stress test Socket.IO (scalabilité)
- Tests de sécurité

---

## 🚀 Déploiement
- Backend Laravel sur VPS ou hébergement dédié
- Socket.IO serveur Node.js dédié
- Certificat SSL obligatoire
- Firebase Cloud Messaging activé

---

## 📄 Documentation API finale
Le développeur backend devra livrer :
- Documentation Swagger complète
- Liste des endpoints + paramètres + réponses
- Exemples d’intégration Flutter
- Erreurs & codes d’état

---

## 📍 Objectif final
Livrer un jeu multijoueur professionnel prêt à publication Google Play / App Store.

---

## 🕹️ Règles du jeu et Gameplay détaillé
Points Master se joue sur un plateau composé de points disposés en grille (ex : 6x6, 8x8 ou 10x10 selon le mode). Les joueurs tracent à tour de rôle une ligne entre deux points adjacents horizontalement ou verticalement.

### 🎯 Objectif du jeu
Former des carrés complets. Chaque carré complété donne **1 point**, et le joueur conserve la main lorsqu’il marque.

### 📐 Règles principales
- Un seul segment peut être posé par tour (sauf si un carré est complété)
- Lorsque le 4ᵉ côté d’un carré est placé, il appartient au joueur qui l’a complété
- Le joueur qui complète un carré rejoue immédiatement
- Lorsque toutes les lignes possibles sont posées, la partie est terminée
- Victoire : joueur avec le **plus grand nombre de carrés**

### 📊 Gestion du plateau
- Le plateau est modélisé par lignes, colonnes et segments disponibles
- Chaque segment a deux états : libre | occupé
- Identifiant unique par segment et carré

### 🧮 Conditions de fin de partie
- Tous les segments possibles sont posés
- Abandon d’un joueur (mode multi)
- Décision de timer automatique (option futur)

---

## 🤖 Mode Solo contre IA
Un mode solo permet au joueur de s’entraîner contre une IA locale.

### Fonctionnement de l’IA
L’IA analyse :
- Segments restants
- Cases critiques (3 côtés déjà présents)
- Opportunités de scoring en chaîne
- Risques de donner un carré à l’adversaire

### Niveau de difficulté prévus
| Niveau | Description |
|--------|-------------|
| Facile | Choix aléatoire hors cases dangereuses |
| Normal | Stratégie de base + calcul probabiliste |
| Expert | Anticipation multi coups, minimax simplifié |

### Mécanique interne IA
- Évaluation par score local (gain immédiat vs risque futur)
- Utilisation d’algorithme heuristique (ex : minimax simplifié)
- Temps de réponse humain simulé pour réalisme

### Communication technique
Le mode IA **ne passe pas par le serveur** :
- Calcul local Flutter
- Pas de websocket nécessaire
- Même logique de plateau que le multi

---

Fin de la version initiale. Ajouts suivants : gameplay détaillé + schéma de données + diagramme architectural.


# Easy Night

## Prérequis

Avant de commencer, assurez-vous de remplacer les variables d'environnement dans le fichier `.env`, ainsi que d'ajouter les credentials de l'API Google dans le fichier `account_key` du back.

## Build de l'APK

Pour construire l'APK, exécutez la commande suivante :

```flutter
flutter build apk
```

## Backend:

### Lancer le backend

Pour lancer le backend, utilisez les commandes suivantes :

```docker
docker compose up -d
docker compose exec api make fixtures
docker compose exec api make swagger
```

### Lancer les tests

```docker
docker compose exec api go test ./internal/controllers/
```

### Lien des productions

API : https://prod.api-easynight.com/
Admin Web : https://esgi-challenge-s4-sigma.vercel.app/

## CONTRIBUTEURS :

- [Nicolas CAPELLA](https://github.com/xxcolas) (xxcolas)
- [Benoit DE CARLI](https://github.com/Benoitapps) (Benoitapps)
- [Bastien PIEDALLU](https://github.com/Stabien) (Stabien)
- [Raphael SELWA](https://github.com/RSelwa) (RSelwa)

### Répartition des tâches :

Nicolas CAPELLA :

- Fonctionnalité : Notification, multilingue, mot de passe oublié, invitation organisateur, consultation des logs, feature flipping (sur la création d'événement)
- Evenements: Création, modification, suppression, géolocalisation
- Participation à la réalisation du: Panel admin, QR Code, tests golang

Benoit DE CARLI :

- Mise en place du temps reel par l'intermiediaire du chat pour les organisateurs
- Affichage des événements, des détails d'un événement,
- Filtre par catégorie, par nom et par lieu
- Reservation d'un événement
- Creation de la partie profil + modification du profil
- Participation à la réalisation du panel admin

Bastien PIEDALLU :

- Mise en place de l'environnement de développement côté back (Docker + air)
- Création de la base de données PostreSQL
- Mise en place de la sécurité côté back
- Création du layout côté front et d'une partie de la navigation
- Gestion de l'authentification (back et front)
- Gestion de l'upload de fichier (back et front)
- Création de la CD avec Terraform, AWS et Github Actions

Raphael SELWA :

- Génération du Qr code
- Qr code Scanner
- Controllers admin back
- Navigation FLutter Web Admin
- Futures Flutter

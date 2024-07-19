# Easy Night

## Prérequis

Avant de commencer, assurez-vous de remplacer les variables d'environnement dans le fichier `.env`.

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

## CONTRIBUTEURS :

- [Nicolas CAPELLA]( https://github.com/xxcolas ) (xxcolas)
- [Benoit DE CARLI]( https://github.com/Benoitapps ) (Benoitapps)
- [Bastien PIEDALLU]( https://github.com/Stabien ) (Stabien)
- [Raphael SELWA]( https://github.com/RSelwa ) (RSelwa)

### Répartition des tâches :
Nicolas CAPELLA :

Benoit DE CARLI :

Bastien PIEDALLU : 
  - Mise en place de l'environnement de développement côté back (Docker + air)
  - Création de la base de données PostreSQL
  - Mise en place de la sécurité côté back
  - Gestion de l'authentification (back et front)
  - Gestion de l'upload de fichier (back et front)
  - Création de la CD avec Terraform, AWS et Github Actions

Raphael SELWA :


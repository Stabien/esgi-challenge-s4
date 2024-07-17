# Easy Night

## Prérequis

Avant de commencer, assurez-vous de remplacer les variables d'environnement dans le fichier `.env`.

## Build de l'APK

Pour construire l'APK, exécutez la commande suivante :
```bash
flutter build apk
```

## Backend:
### Lancer le backend
Pour lancer le backend, utilisez les commandes suivantes :
```bash
docker compose up -d
docker compose exec api make fixtures
docker compose exec api make swagger
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

Raphael SELWA :


# Pier76 Vehicles

Collection de véhicules personnalisés pour FiveM avec menu de gestion intégré.

## Installation

1. Créez un dossier `[pier76vehicles]` dans votre dossier `resources` :
```bash
cd txData/cxdefault/resources
mkdir [pier76vehicles]
```

2. Clonez le projet dans ce dossier :
```bash
cd [pier76vehicles]
git clone [URL_DU_REPO] .
```

3. Ajoutez la ressource dans votre `server.cfg` :
```
ensure [pier76vehicles]/[compacts]
ensure [pier76vehicles]/[sedans]
ensure [pier76vehicles]/[coupes]
ensure [pier76vehicles]/[muscle]
ensure [pier76vehicles]/[sports]
ensure [pier76vehicles]/[super]
ensure [pier76vehicles]/[suvs]
ensure [pier76vehicles]/[vans]
ensure [pier76vehicles]/[cycles]
ensure [pier76vehicles]/[tools]/pier76menu
```

## Menu Pier76

Le menu de gestion des véhicules est accessible via la commande **/vmenu**.

### Fonctionnalités

#### Onglet Véhicules
- Recherche de véhicules par catégorie
- Spawn de véhicules
- Suppression du véhicule actuel
- Réparation du véhicule

#### Onglet Réglages
- Modification en temps réel des propriétés de handling
- Plus de 40 paramètres modifiables
- Bouton de réinitialisation par défaut
- Reset individuel pour chaque paramètre

#### Onglet Modkit

**Section Animations**
- Ouverture/fermeture des portes, capot, coffre
- Détection dynamique des portes disponibles

**Section Fonctions**
- Moteur ON/OFF
- Lumières ON/OFF
- Feux de stop
- Clignotants (gauche, droit, warning)
- Klaxon continu

**Section Environnement**
- Changer l'heure (Jour/Nuit)

**Section Extérieur**
- Pièces de carrosserie (aileron, pare-chocs, etc.)
- Couleur primaire/secondaire
- Couleur des roues
- Néons (7 couleurs)
- Teinte des vitres
- Type de roues
- Livrées

**Section Intérieur**
- Garnitures, sièges, volant
- Couleurs intérieures

**Section Propriétés**
- Moteur, freins, transmission
- Suspension, turbo
- Blindage, hydraulique

### Caméra libre

Dans l'onglet Modkit, appuyez sur **X** pour activer/désactiver la caméra libre et inspecter votre véhicule.

### Commandes

- **/pier76menu** : Ouvrir/fermer le menu des véhicules

## Catégories de véhicules

- **Compacts** : Petites voitures de ville
- **Sedans** : Berlines
- **Coupes** : Voitures sportives compactes
- **Muscle** : Muscle cars américaines
- **Sports** : Sportives normales
- **Super** : Hyper cars / supercars
- **SUVs** : 4×4 urbains
- **Vans** : Vans / fourgons
- **Cycles** : Motos sportives

## Structure du projet

```
[pier76vehicles]/
├── [compacts]/
├── [sedans]/
├── [coupes]/
├── [muscle]/
├── [sports]/
├── [super]/
├── [suvs]/
├── [vans]/
├── [cycles]/
├── [tools]/
│   └── pier76menu/
│       ├── client/
│       │   ├── main.lua
│       │   ├── vehicles.lua
│       │   ├── settings.lua
│       │   ├── modkit.lua
│       │   └── modkit/
│       │       ├── animations.lua
│       │       ├── fonctions.lua
│       │       ├── environment.lua
│       │       ├── exterior.lua
│       │       ├── interior.lua
│       │       └── properties.lua
│       ├── html/
│       │   ├── index.html
│       │   ├── style.css
│       │   └── script.js
│       ├── config.lua
│       └── fxmanifest.lua
└── README.md
```

## Configuration

Pour ajouter un véhicule au menu, éditez le fichier `[tools]/pier76menu/config.lua` :

```lua
Config.Vehicles = {
    {
        category = "Compacts",
        vehicles = {
            {name = "Nom du véhicule", model = "nom_spawn"},
        }
    },
}
```

## Support

Pour toute question ou problème, veuillez ouvrir une issue sur le dépôt GitHub.

## Licence

Ce projet est sous licence libre. Voir le fichier LICENSE pour plus de détails.

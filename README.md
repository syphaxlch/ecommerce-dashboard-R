# Dashboard E-commerce – Projet INF416 H2025

[**Voir le dashboard en ligne**](https://ecommerce-dashboard.shinyapps.io/projet_4inf416_h2025-main/)

## 🎯 Objectif du projet

Ce projet vise à développer un tableau de bord interactif pour l'analyse des ventes d'une plateforme e-commerce. L'objectif est de :

* Visualiser les tendances des ventes au fil du temps.
* Identifier les produits les plus vendus.
* Analyser les performances des ventes par région et par segment de clientèle.
* Fournir des outils interactifs pour une exploration dynamique des données.

## 🛠️ Technologies utilisées

* **R** : Langage de programmation principal.
* **Shiny** : Framework pour la création d'applications web interactives.
* **shinydashboard** : Interface utilisateur de type tableau de bord.
* **Plotly** : Bibliothèque pour la création de graphiques interactifs.
* **dplyr** : Package pour la manipulation des données.

## 📂 Structure du projet

```
/projet_4inf416_h2025-main/
│
├── app.R          # Script principal de l'application Shiny
├── data/          # Dossier contenant les jeux de données
│   └── sales_data.csv
├── www/           # Dossier pour les ressources statiques (CSS, images)
│   └── style.css
└── README.md      # Documentation du projet
```

## 🚀 Instructions d'utilisation

1. Clonez ce repository sur votre machine locale.
2. Installez les dépendances R nécessaires :

   ```R
   install.packages(c("shiny", "shinydashboard", "plotly", "dplyr"))
   ```
3. Lancez l'application Shiny :

   ```R
   shiny::runApp("app.R")
   ```
4. Ouvrez votre navigateur et accédez à `http://localhost:3838` pour visualiser le tableau de bord.

## 📄 Licence

Ce projet est sous licence MIT – voir le fichier [LICENSE](LICENSE) pour plus de détails.

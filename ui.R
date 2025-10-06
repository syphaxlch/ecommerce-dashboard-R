library(shiny)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #121212;
        color: white;
      }
      .tab-content {
        padding-top: 20px;
      }
      .navbar-default {
        background-color: #1f1f1f;
        border-color: #444;
      }
      .navbar-default .navbar-nav > li > a {
        color: white;
      }
      .navbar-default .navbar-nav > li > a:hover {
        background-color: #333;
      }
      .well{
        background-color: black;
      }
      #afficher_ventes {
        background-color: #222;
        color: white;
        border: 1px solid #555;
        border-radius: 5px;
        padding: 10px 20px;
        transition: background-color 0.3s, border-color 0.3s;
      }
      #afficher_ventes:hover {
        background-color: #007BFF;
        border-color: #007BFF;
        cursor: pointer;
      }
      #afficher_ventes:focus {
        outline: none;
        box-shadow: none;
      }
      #afficher_ventes:active {
        transform: scale(0.95);
        transition: transform 0.1s;
      }


    "))
  ),
  
  navbarPage(
    title = "Dashboard E-commerce",
    id = "tabs",
    inverse = TRUE,
    
    tabPanel("Accueil",
             fluidRow(
               column(6,
                      div(style = "border: 1px solid #444; padding: 10px; border-radius: 10px; height: 100%;",
                          fluidRow(
                            column(12,
                                   div(style = "height: 30%;",
                                       fluidRow(
                                         column(4,
                                                div(style = "background-color: #222; padding: 20px; border-radius: 10px; border: 1px solid #555;",
                                                    h4("💰 Total des ventes"),
                                                    textOutput("total_ventes")
                                                )
                                         ),
                                         column(4,
                                                div(style = "background-color: #222; padding: 20px; border-radius: 10px; border: 1px solid #555;",
                                                    h4("👥 Accès total"),
                                                    textOutput("nombre_acces")
                                                )
                                         ),
                                         column(4,
                                                div(style = "background-color: #222; padding: 20px; border-radius: 10px; border: 1px solid #555;",
                                                    h4("⏱️ Durée totale"),
                                                    textOutput("duree_totale")
                                                )
                                         )
                                       )
                                   )
                            )
                          ),
                          fluidRow(
                            column(12,
                                   div(style = "height: 70%; padding-top: 20px; background-color: #1a1a1a; border: 1px solid #555; border-radius: 10px; padding: 20px;",
                                       #Titre
                                       h3("Évolution des ventes", style = "text-align: center;"),
                                       
                                       #Sous-Titre
                                       h3(style = "color: white; margin-bottom: 15px;", "Sélectionner les pays :"),
                                       
                                       #Les cases Pays
                                       div(
                                         style = "column-count: 3; column-gap: 15px;",
                                         checkboxGroupInput(
                                           "selected_countries",
                                           label = NULL, # Pas de label ici, il est déjà au-dessus
                                           choices = NULL # Initialement vide, rempli par observe() dans server
                                         )
                                       ),
                                       
                                       #Bouton
                                       actionButton("afficher_ventes", "Afficher les ventes",
                                                    style = "margin-top: 20px; margin-bottom: 20px;"),
                                       
                                       #Graphique
                                       plotOutput("ventes_evolution_plot", height = "300px")
                                   )
                            )
                          )
                      )
               ),
               
               column(6,
                      div(style = "border: 1px solid #444; padding: 10px; border-radius: 10px; height: 100%; display: flex; flex-direction: column;background-color: black;",
                          div(style = "border: 1px solid #555; border-radius: 10px; padding: 15px; margin-bottom: 10px;",
                              h4("Profile & comportement")
                          ),
                          div(style = "border: 1px solid #555; border-radius: 10px; padding: 15px; flex: 1 1 50%; margin-bottom: 10px; overflow-y: auto;",
                              h5("Échelle logarithmique sur la durée"),
                              plotOutput("log_duree_plot", height = "300px")  # hauteur fixe
                          ),
                          div(style = "border: 1px solid #555; border-radius: 10px; padding: 10px; flex: 1 1 50%; display: flex; gap: 10px; overflow-y: auto;",
                              div(style = "flex: 1; border: 1px solid #666; border-radius: 10px; padding: 10px; background-color: #222;",
                                  h5("Répartition des ventes par pays"),
                                  plotOutput("ventes_pays_plot", height = "300px")  # hauteur fixe
                              ),
                              div(style = "flex: 1; border: 1px solid #666; border-radius: 10px; padding: 10px; background-color: #222;",
                                  h5("Répartition des produits retournés"),
                                  plotOutput("retours_produits_plot", height = "300px")  # hauteur fixe
                              )
                          )
                      )
               )
             )
    ),
    
    tabPanel("Tableau des ventes",
             fluidPage(
               h4("Aperçu des données"),
               div(style = "width: 100%; overflow-x: auto;",
                   tableOutput("table_preview")
               ),
               hr(),
               h4("Statistiques descriptives pour les ventes"),
               fluidRow(
                 column(
                   width = 4,
                   div(style = "background-color: black; padding: 15px; border-radius: 10px; border: 1px solid #444;",
                       checkboxGroupInput(
                         "stats_cols",
                         "Sélectionner les statistiques à afficher :",
                         choices = c("Médiane" = "median",
                                     "Moyenne" = "mean",
                                     "Minimum" = "min",
                                     "Maximum" = "max",
                                     "Écart-type" = "sd"),
                         selected = c("median", "mean", "min", "max", "sd")
                       )
                   )
                 ),
                 column(
                   width = 8,
                   tableOutput("stats_table")
                 )
               )
             )
    )
  )
)
library(shiny)
library(readr)
library(dplyr)
library(ggplot2)

clean_names <- function(names_vec) {
  names_vec %>%
    tolower() %>%
    gsub("[()]", "", .) %>%
    gsub(" ", "_", .) %>%
    gsub("-", "_", .) %>%
    gsub("__+", "_", .) %>%
    gsub("duration_secs", "duration", .)
}

data <- read_csv("ecommerce_logs.csv")
names(data) <- clean_names(names(data))

# Table de correspondance entre pays et codes ISO
country_codes <- c(
  "CA" = "Canada",
  "AR" = "Argentina",
  "PL" = "Poland",
  "IN" = "India",
  "KR" = "South Korea",
  "CN" = "China",
  "AT" = "Austria",
  "US" = "United States",
  "SE" = "Sweden",
  "CH" = "Switzerland",
  "NO" = "Norway",
  "JP" = "Japan",
  "GB" = "United Kingdom",
  "MX" = "Mexico",
  "IT" = "Italy",
  "RU" = "Russia",
  "DE" = "Germany",
  "AU" = "Australia",
  "FI" = "Finland",
  "PR" = "Puerto Rico",
  "DK" = "Denmark",
  "CO" = "Colombia",
  "AE" = "United Arab Emirates",
  "IE" = "Ireland",
  "PE" = "Peru",
  "ZA" = "South Africa",
  "FR" = "France"
)

# noms (names) = "Canada (CA)", valeurs = "Canada"
country_labels <- paste0(names(country_codes), " (", country_codes, ")")
choices_list <- setNames(names(country_codes), country_labels)

server <- function(input, output, session) {
  
  observe({
    numeric_cols <- names(select_if(data, is.numeric))
    updateSelectInput(session, "col", choices = numeric_cols, selected = numeric_cols[1])
  })
  
  output$total_ventes <- renderText({
    total <- sum(data$sales, na.rm = TRUE)
    paste0(format(round(total, 2), big.mark = " "), " $")
  })
  
  output$nombre_acces <- renderText({
    format(nrow(data), big.mark = " ")
  })
  
  output$duree_totale <- renderText({
    total_minutes <- sum(data$duration, na.rm = TRUE) / 60
    days <- floor(total_minutes / 1440)
    hours <- floor((total_minutes %% 1440) / 60)
    minutes <- round(total_minutes %% 60)
    paste0(days, " jours, ", hours, " h, ", minutes, " min")
  })
  
  output$log_duree_plot <- renderPlot({
    # On agrège les données par durée pour calculer le montant total des ventes par durée
    ventes_par_duree <- data %>%
      group_by(duration) %>%
      summarise(total_ventes = sum(sales, na.rm = TRUE)) %>%
      filter(duration > 0)  # nécessaire pour échelle log (pas de 0 ni négatifs)
    
    ggplot(ventes_par_duree, aes(x = duration, y = total_ventes)) +
      geom_point(color = "skyblue") +
      geom_line(color = "skyblue") +
      scale_x_log10() +
      labs(
        x = "Durée (échelle logarithmique)",
        y = "Montant des ventes ($)",
        title = "Graphique semi-logarithmique des ventes selon la durée"
      ) +
      theme_minimal(base_family = "Arial") +
      theme(
        plot.background = element_rect(fill = "#121212"),
        panel.background = element_rect(fill = "#121212"),
        text = element_text(color = "white"),
        axis.text = element_text(color = "white")
      )
  })
  
  output$ventes_pays_plot <- renderPlot({
    ventes_par_pays <- data %>%
      group_by(country) %>%
      summarise(total = sum(sales, na.rm = TRUE)) %>%
      arrange(desc(total)) %>%
      head(10)
    
    ggplot(ventes_par_pays, aes(x = reorder(country, total), y = total)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      labs(x = "Pays", y = "Ventes totales") +
      theme_minimal(base_family = "Arial") +
      theme(
        plot.background = element_rect(fill = "#121212"),
        panel.background = element_rect(fill = "#121212"),
        text = element_text(color = "white"),
        axis.text = element_text(color = "white")
      )
  })
  
  output$retours_produits_plot <- renderPlot({
    retours <- data %>%
      group_by(returned) %>%
      summarise(nombre = n())
    
    ggplot(retours, aes(x = "", y = nombre, fill = factor(returned))) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y") +
      labs(fill = "Retourné") +
      theme_void() +
      theme(
        legend.position = "bottom",
        plot.background = element_rect(fill = "#121212"),
        text = element_text(color = "white")
      )
  })
  
  output$table_preview <- renderTable({
    head(data, 10)
  })
  
  output$stats_table <- renderTable({
    req(input$stats_cols)
    
    # Colonnes numériques pour stats - ici on prend "sales" par défaut
    cols_to_summarize <- "sales"
    
    # Calcul des stats selon la sélection
    stats_list <- list(
      median = median(data[[cols_to_summarize]], na.rm = TRUE),
      mean = mean(data[[cols_to_summarize]], na.rm = TRUE),
      min = min(data[[cols_to_summarize]], na.rm = TRUE),
      max = max(data[[cols_to_summarize]], na.rm = TRUE),
      sd = sd(data[[cols_to_summarize]], na.rm = TRUE)
    )
    
    # Filtrer selon sélection
    stats_selected <- stats_list[input$stats_cols]
    
    # Formatage en data.frame pour affichage
    stats_df <- data.frame(
      Statistique = names(stats_selected),
      Valeur = unlist(stats_selected)
    )
  
  output$stats_table <- renderTable({
    req(input$stats_cols)
    
    stats_list <- list(
      median = median(data$sales, na.rm = TRUE),
      mean = mean(data$sales, na.rm = TRUE),
      min = min(data$sales, na.rm = TRUE),
      max = max(data$sales, na.rm = TRUE),
      sd = sd(data$sales, na.rm = TRUE)
    )
    
    # Sélectionner seulement les stats cochées
    selected_keys <- input$stats_cols
    stats_selected <- stats_list[selected_keys]
    
    # Créer le tableau
    stats_df <- data.frame(
      Statistique = selected_keys,
      Valeur = unname(unlist(stats_selected))
    )
    
    # Traduire les noms
    stats_df$Statistique <- dplyr::recode(stats_df$Statistique,
                                          median = "Médiane",
                                          mean = "Moyenne",
                                          min = "Minimum",
                                          max = "Maximum",
                                          sd = "Écart-type")
    
    stats_df
  })
  

  })
  
#Evolution des ventes

 observe({
      updateCheckboxGroupInput(
        session,
        "selected_countries",
        choices = choices_list,
        selected = names(country_codes)[1:5]  # sélection par défaut, modifiable
      )
    })
    
    ventes_par_temps <- eventReactive(input$afficher_ventes, {
      req(input$selected_countries)
      
      data %>%
        mutate(accessed_date = as.Date(accessed_date)) %>%
        filter(country %in% input$selected_countries) %>%  # filtre avec les noms simples
        group_by(accessed_date, country) %>%
        summarise(total_ventes = sum(sales, na.rm = TRUE), .groups = "drop") %>%
        arrange(accessed_date) %>%
        mutate(country_label = paste(country, "(", country_codes[country], ")", sep = ""))
    })
    
    output$ventes_evolution_plot <- renderPlot({
      ggplot(ventes_par_temps(), aes(x = accessed_date, y = total_ventes, color = country)) +
        geom_line(size = 1) +
        labs(x = "Date", y = "Ventes totales", color = "Pays",
             title = "Évolution des ventes par pays (par jour)") +
        theme_minimal(base_family = "Arial") +
        theme(
          plot.background = element_rect(fill = "#121212"),
          panel.background = element_rect(fill = "#121212"),
          text = element_text(color = "white"),
          axis.text = element_text(color = "white"),
          legend.title = element_text(color = "white"),
          legend.text = element_text(color = "white")
        )
    })
  
  
}

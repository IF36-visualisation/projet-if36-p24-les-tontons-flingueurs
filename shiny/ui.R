library(shinydashboard)
library(dplyr)
library(readr)

genres <- unique(read_csv("../data/mxmh_survey_results.csv", show_col_types = FALSE)$`Fav genre`)

ui <- dashboardPage(
    skin = "green",
    dashboardHeader(title = "Genre musicaux et santé - Les tontons flingueurs - IF36"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Présentation du dataset", tabName = "presentation", icon = icon("th", lib="glyphicon")),
        menuItem("Corrélations entre musique et santé", tabName = "correlations", icon = icon("chart-column"))
      )
    ),
    dashboardBody(
      tags$head(
        tags$style(type = "text/css", "
          #genres_medical_vs_fav_genre .shiny-options-group {
            display: flex;
            flex-wrap: wrap;
            gap: 0 3rem;
          }
          #genres_medical_vs_fav_genre .shiny-options-group .checkbox {
            margin-top: 10px;
          }
          .dimension_selection_div {
            display: flex;
            gap: 2rem;
            justify-content : center;
          }
          
          #shiny-tab-correlations .col-sm-6 {
            width: 100%;
          }
          "
                   )
        ),
      tabItems(
        tabItem(tabName="presentation",
                box(title = "Relation entre le style de musique préféré et certains problèmes médicaux",
                    plotOutput("fav_genre_by_filter"),
                    selectInput("filter_column_for_fav_genre", "Sélectionner un problème médical", choices = list("Dépression" = "Depression", "Anxiété" = "Anxiety", "Insomnie" = "Insomnia", "OCD" = "OCD")),
                    checkboxGroupInput("genres_medical_vs_fav_genre", "Genres à inclure sur le graphique", choices = genres, selected = genres)
                    ),
                box(title = "Relation entre le temps d'écoute quotidienne de musique et certains problèmes médicaux",
                    plotOutput("trouble_intensity_by_time"),
                    selectInput("trouble_for_trouble_vs_time", "Sélectionner un problème médical", choices = list("Dépression" = "Depression", "Anxiété" = "Anxiety", "Insomnie" = "Insomnia", "OCD" = "OCD")),
                    sliderInput("time_range_for_trouble_vs_time", "Temps maximal d'écoute dans le graphe", min = 0, max = 24, value = c(0, 10)),
                    sliderInput("horizontal_bins_for_trouble_vs_time", "Nombre de bins (horizontal)", min = 1, max = 48, value = 11),
                    sliderInput("vertical_bins_for_trouble_vs_time", "Nombre de bins (vertical)", min = 2, max = 21, value = 11)
                    )
                ),
        tabItem(tabName = "correlations",
                box(title = "Corrélations entre les différents types de musique",
                    plotOutput("genres_correlation"),
                    div(class="dimension_selection_div",
                        selectInput("dimension_absisses_genres_correlation", "Sélectionnez la dimension à afficher en absisses", choices = list("Dimension 1" = "1", "Dimension 2" = "2", "Dimension 3" = "3", "Dimension 4" = "4", "Dimension 5" = "5")),
                        selectInput("dimension_ordinates_genres_correlation", "Sélectionnez la dimension à afficher en ordonnées", choices = list("Dimension 1" = "1", "Dimension 2" = "2", "Dimension 3" = "3", "Dimension 4" = "4", "Dimension 5" = "5"), selected = "2")
                        ),
                    plotOutput("genres_correlation_quality")
                    )
                )
        )
      )
    )

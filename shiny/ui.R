library(shinydashboard)
library(dplyr)
library(readr)

genres <- unique(read_csv("../data/mxmh_survey_results.csv", show_col_types = FALSE)$`Fav genre`)

ui <- dashboardPage(
    skin = "green",
    dashboardHeader(title = "Genre musicaux et santé - Les tontons flingueurs - IF36"),
    dashboardSidebar(),
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
          "
                   )
        ),
      box(title = "coucou :)",
          plotOutput("fav_genre_by_filter"),
          selectInput("filter_column_for_fav_genre", "Sélectionner le champ avec lequel comparer", choices = list("Dépression" = "Depression", "Anxiété" = "Anxiety", "Insomnie" = "Insomnia", "OCD" = "OCD")),
          checkboxGroupInput("genres_medical_vs_fav_genre", "Genres à inclure sur le graphique", choices = genres, selected = genres)
          )
      )
)

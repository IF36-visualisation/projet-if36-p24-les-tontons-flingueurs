library(ggplot2)
library(tidyr)
library(readr)
library(viridis)
library(dplyr)

server <- function(input, output) {
  set.seed(42)

  data <- reactive({
    df <- read_csv("../data/mxmh_survey_results.csv", show_col_types = FALSE)
    df <- df %>% filter(`Fav genre` %in% input$genres_medical_vs_fav_genre)
    return (df %>% group_by(`Fav genre`, df[input$filter_column_for_fav_genre]))
  });

  output$fav_genre_by_filter <- renderPlot({
    df_fav_genre_by_filter <- data() %>%
      summarise(nb_total = n()) %>%
      spread(key = input$filter_column_for_fav_genre, value = nb_total, fill = 0)
    for (i in 0:10) {
      if (!(as.character(i) %in% names(df_fav_genre_by_filter))) {
        df_fav_genre_by_filter[[as.character(i)]] <- rep(0, nrow(df_fav_genre_by_filter))
      }
    }
    if ("3.5" %in% df_fav_genre_by_filter) {
      df_fav_genre_by_filter <- df_fav_genre_by_filter %>% mutate(`4` = `4` + `3.5`, -`3.5`)
    }
    if ("5.5" %in% df_fav_genre_by_filter) {
      df_fav_genre_by_filter <- df_fav_genre_by_filter %>% mutate(`6` = `6` + `5.5`, -`5.5`)
    }
    if ("7.5" %in% df_fav_genre_by_filter) {
      df_fav_genre_by_filter <- df_fav_genre_by_filter %>% mutate(`8` = `8` + `7.5`, -`7.5`)
    }
    if ("8.5" %in% df_fav_genre_by_filter) {
      df_fav_genre_by_filter <- df_fav_genre_by_filter %>% mutate(`9` = `9` + `8.5`, -`8.5`)
    }

    names(df_fav_genre_by_filter)[-1] <- paste0("step", colnames(df_fav_genre_by_filter)[-1])
    total = rowSums(df_fav_genre_by_filter[-1])
    df_fav_genre_by_filter$total <- total
    print(df_fav_genre_by_filter)
    df_fav_genre_by_filter <- df_fav_genre_by_filter %>%
      rename(value = `Fav genre`) %>%
      mutate(step0 = step0 / total * 100,
               step1 = step1 / total * 100,
               step2 = step2 / total * 100,
               step3 = step3 / total * 100,
               step4 = step4 / total * 100,
               step5 = step5 / total * 100,
               step6 = step6 / total * 100,
               step7 = step7 / total * 100,
               step8 = step8 / total * 100,
               step9 = step9 / total * 100,
               step10 = step10 / total * 100)
    column_to_word <- list("Depression" = c("de dépression", "la dépression"), "Anxiety" = c("d'anxiété", "l'anxiété"), "Insomnia" = c("d'insomnie", "l'insomnie"), "OCD" = c("d'OCD", "les OCD"))
    return (ggplot(df_fav_genre_by_filter, aes(x = value)) +
              geom_col(aes(y = step10 + step9 + step8 + step7 + step6 + step5 + step4 + step3 + step2 + step1 + step0, fill = 10), position = "identity") +
              geom_col(aes(y = step9 + step8 + step7 + step6 + step5 + step4 + step3 + step2 + step1 + step0, fill = 9), position = "identity") +
              geom_col(aes(y = step8 + step7 + step6 + step5 + step4 + step3 + step2 + step1 + step0, fill = 8), position = "identity") +
              geom_col(aes(y = step7 + step6 + step5 + step4 + step3 + step2 + step1 + step0, fill = 7), position = "identity") +
              geom_col(aes(y = step6 + step5 + step4 + step3 + step2 + step1 + step0, fill = 6), position = "identity") +
              geom_col(aes(y = step5 + step4 + step3 + step2 + step1 + step0, fill = 5), position = "identity") +
              geom_col(aes(y = step4 + step3 + step2 + step1 + step0, fill = 4), position = "identity") +
              geom_col(aes(y = step3 + step2 + step1 + step0, fill = 3), position = "identity") +
              geom_col(aes(y = step2 + step1 + step0, fill = 2), position = "identity") +
              geom_col(aes(y = step1 + step0, fill = 1), position = "identity") +
              geom_col(aes(y = step0, fill = 0), position = "identity") +
              labs(x = "Style de musique préféré", y = paste("Proportion (%) de personnes par niveau", column_to_word[[input$filter_column_for_fav_genre]][1]),
                   title = paste("Relation entre le style de musique préféré et", column_to_word[[input$filter_column_for_fav_genre]][2])) +
              theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
              scale_fill_viridis(name = paste("Niveau", column_to_word[[input$filter_column_for_fav_genre]][1]), direction = -1))
  })
}

library(ggplot2)
library(tidyr)
library(readr)
library(viridis)
library(dplyr)
library(FactoMineR)
library(factoextra)

server <- function(input, output) {
  set.seed(42)
  medical_issue_to_word <- list("Depression" = c("de dépression", "la dépression", "de la dépression"),
                                "Anxiety" = c("d'anxiété", "l'anxiété", "de l'anxiété"),
                                "Insomnia" = c("d'insomnie", "l'insomnie", "de l'insomnie"),
                                "OCD" = c("d'OCD", "les OCD", "des OCD"))
  
  df <- reactive({
    return (read_csv("../data/mxmh_survey_results.csv", show_col_types = FALSE))
  })

  df_fav_genre_by_filter <- reactive({
    df_fav_genre_by_filter <- df() %>% filter(`Fav genre` %in% input$genres_medical_vs_fav_genre)
    return (df_fav_genre_by_filter %>% group_by(`Fav genre`, df_fav_genre_by_filter[input$filter_column_for_fav_genre]))
  })

  mca <- reactive({
    df_frequency_formatted <- df()
    frequency_columns <- colnames(df_frequency_formatted)[grep("^Frequency", colnames(df_frequency_formatted))]
    df_frequency_formatted <- df_frequency_formatted[frequency_columns]
    # On enlève le préfixe "Frequency" au nom des variables
    remove_frequency_prefix <- function(col_name) {
      col_name <- sub("^Frequency \\[", "", col_name)
      sub("]$", "", col_name)
    }
    colnames(df_frequency_formatted) <- sapply(colnames(df_frequency_formatted), remove_frequency_prefix)
    # On fait l'AFC
    return (MCA(df_frequency_formatted, graph = FALSE))
  })

  mca_axis <- reactive({
    return (c(as.integer(input$dimension_absisses_genres_correlation),
              as.integer(input$dimension_ordinates_genres_correlation)))
  })

  output$fav_genre_by_filter <- renderPlot({
    df_fav_genre_by_filter <- df() %>%
      filter(`Fav genre` %in% input$genres_medical_vs_fav_genre)
    df_fav_genre_by_filter <- df_fav_genre_by_filter %>%
      group_by(`Fav genre`, df_fav_genre_by_filter[input$filter_column_for_fav_genre]) %>%
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
              labs(x = "Style de musique préféré", y = paste("Proportion (%) de personnes par niveau", medical_issue_to_word[[input$filter_column_for_fav_genre]][1]),
                   title = paste("Relation entre le style de musique préféré et", medical_issue_to_word[[input$filter_column_for_fav_genre]][2])) +
              theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
              scale_fill_viridis(name = paste("Niveau", medical_issue_to_word[[input$filter_column_for_fav_genre]][1]), direction = -1))
  })
  
  output$trouble_intensity_by_time <- renderPlot({
    df_hours_pivot <- df() %>%
      filter(`Music effects` != "" & !is.na(`Music effects`)) %>%
      select(Anxiety, Depression, Insomnia, OCD, `Music effects`, `Hours per day`) %>%
      pivot_longer(!c(`Music effects`, `Hours per day`), names_to = "maladie", values_to = "niveau") %>%
      mutate(niveau = round(niveau / 10 * (input$vertical_bins_for_trouble_vs_time - 1)) / (input$vertical_bins_for_trouble_vs_time - 1) * 10) %>%
      #mutate(niveau = round(niveau)) %>%
      filter(input$time_range_for_trouble_vs_time[1] <= `Hours per day` & `Hours per day` <= input$time_range_for_trouble_vs_time[2]) %>%
      mutate(`Hours per day` = round((`Hours per day` - input$time_range_for_trouble_vs_time[1]) * (input$horizontal_bins_for_trouble_vs_time - 1) / (input$time_range_for_trouble_vs_time[2] - input$time_range_for_trouble_vs_time[1])) * (input$time_range_for_trouble_vs_time[2] - input$time_range_for_trouble_vs_time[1]) / (input$horizontal_bins_for_trouble_vs_time - 1) + input$time_range_for_trouble_vs_time[1]) %>%
      filter(maladie == input$trouble_for_trouble_vs_time)
    df_hours_pivot$niveau <- factor(df_hours_pivot$niveau)
    return (ggplot(df_hours_pivot) +
              aes(x = `Hours per day`, fill = niveau) +
              geom_bar(position = "fill") +
              scale_fill_brewer(palette = "RdYlGn", direction = -1) +
              scale_y_continuous(labels = scales::percent_format(), expand = c(0,0)) +
              labs(title = paste("Etude de la corrélation entre le niveau", medical_issue_to_word[[input$trouble_for_trouble_vs_time]][1], "et le temps d'écoute"),
                    x = "Temps d'écoute journalier (en heures)",
                    y = paste("Proportion de l'intensité", medical_issue_to_word[[input$trouble_for_trouble_vs_time]][3])) +
              theme(plot.title = element_text(size = 14, hjust = 0.5),
                    legend.position = "top",
                    panel.spacing.x=unit(0.5, "lines"),
                    panel.spacing.y=unit(0.5, "lines")))
  })
  
  output$genres_correlation <- renderPlot({
    # We have to directly modify the MCA results
    mca_modified <- mca()
    mca_modified$var$eta2 <- mca_modified$var$eta2[, mca_axis()]
    return (plot(fviz_mca_var(mca_modified, choice = "mca.cor", repel = TRUE, ggtheme = theme_minimal())))
  })
  
  output$genres_correlation_quality <- renderPlot({
    sum_values <- (mca()$var$eta2[,mca_axis()[1]] ^ 2 + mca()$var$eta2[,mca_axis()[2]] ^ 2) / rowSums(mca()$var$eta2 ^ 2)
    if (mca_axis()[1] == mca_axis()[2]) {
      sum_values <- sum_values / 2
    }
    data <- data.frame(style = names(sum_values), precision = sum_values)
    data$style <- factor(data$style, levels = data$style[order(-data$precision)])
    return (ggplot(data, aes(x = style, y = precision)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "Qualité de représentation des styles", x = "Style de musique", y = "Qualité de représentation") +  # Add title and axis labels
      theme_minimal() + # Apply a minimal theme
      theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels by 90 degrees
    )
  })
}

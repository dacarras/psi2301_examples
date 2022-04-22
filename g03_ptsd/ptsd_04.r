
# abrir datos
ptsd_data <- read.csv(
  url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
  )
)


# agregar función de puntajes cmoo medias de respuestas
mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}

# crear puntaje promedio
ptsd_data <- ptsd_data %>% 
             mutate(war_mean = mean_score(
                      war1,
                      war2,
                      war3,
                      war4,
                      war5,
                      war6,
                      war7,
                      war8)
                      ) 

# histograma con puntaje promedio, para mostrar que existe
hist(ptsd_data$war_mean)
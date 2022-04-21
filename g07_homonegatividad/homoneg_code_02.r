# abrir datos
data_hom <- read.csv2(
url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/homonegatividad.csv'
	), na = -99
)

# mostrar datos
dplyr::glimpse(data_hom)


# codigo para producir porcentaje de respuesta para una matriz de itmes
wide_resp <- function (x) {
    options(warn = -1)
    require(dplyr)
    y <- as.data.frame(x)
    x <- mutate_all(x, funs(replace(., is.na(.), -999)))
    order_table <- data.frame(variable = as.character(names(x)), 
        var_order = seq(1:length(names(x))))
    
    table_freq <- function(x) {
        as.data.frame(table(x))
    }
    
    table <- lapply(x, table_freq) %>%dplyr::bind_rows(., .id = "var") %>% 
        rename(resp = x, n = Freq) %>% group_by(var) %>% mutate(per = n/sum(n)) %>% 
        mutate(resp = as.character(resp)) %>% mutate(resp = case_when(nchar(resp) == 
        1 ~ paste0(0, resp), TRUE ~ as.character(resp))) %>% 
        mutate(resp = if_else(resp == "-999", "NA", resp)) %>% 
        arrange(resp) %>% dplyr::select(var, resp, per)
    
    wide_resp <- tidyr::spread(table, resp, per) %>% 
        rename(variable = var) %>% 
        left_join(., order_table, by = "variable") %>%
        dplyr::select(-var_order)
    
    return(wide_resp)
    options(warn = 0)
}


# aplicar sobre dos items seleccionados
library(dplyr)
data_hom %>%
dplyr::select(homo1gay, homo1les) %>%
wide_resp() %>%
knitr::kable(., digits = 2)

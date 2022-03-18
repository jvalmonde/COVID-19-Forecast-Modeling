library('magrittr')
library('bigrquery')
library('data.table')
library('here')

options("httr_oauth_cache"="~/.httr-oauth", httr_oob_default = TRUE)

# Database for COVID-19 Forecast Modeling project
database <- "df_enrichment"

# Read datasets from research-01 server
master_table_name <- c(paste0(database, ".cds_covid19_states_daily_4pm_et"),
                       paste0(database, ".cds_covid19_cases_by_geography"),
                       paste0(database, ".cds_covid19_msa_summary"))

# RDS file names
master_rds_file <- c("states_daily.rds", "cases_by_geography.rds", "msa_summary.rds")

# Reading the master table for each pilot
for(i in 1:length(master_table_name)){
  
  table <- data.table(bq_project_query("research-01-217611", 
                                       paste0("SELECT * FROM ", master_table_name[i]), 
                                       use_legacy_sql = F, quiet = F) %>% bq_table_download())
  # setkeyv(table, c('state', 'date'))
 
  saveRDS(table, here::here("Data", "Raw", master_rds_file[i]))
  
}





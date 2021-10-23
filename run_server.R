library(plumber)
message("==== starting model server ===")
source("functions.R")
pr("plumber.R") %>%
    pr_hook("exit", function(){
        message("=== Closing model server ===")
    }) %>% 
    pr_run(port=4900)

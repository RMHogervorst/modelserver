library(plumber)
library(logger)
log_threshold(INFO) # one of TRACE/DEBUG/INFO/WARNING/ERROR
log_layout(layout_glue_colors)
log_info("==== starting model server ===")
source("functions.R")
pr("plumber.R") %>%
    pr_hook("exit", function(){
        log_info("=== Closing model server ===")
    }) %>% 
    pr_run(port=4900)

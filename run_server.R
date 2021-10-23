library(plumber)
source("functions.R")
pr("plumber.R") %>%
    pr_run(port=8000)

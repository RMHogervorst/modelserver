library(plumber)
print("==== starting model server ===")
source("functions.R")
pr("plumber.R") %>%
    pr_run(port=8000)

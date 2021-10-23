library(RSQLite)
library(DBI)


fail_on_missing_id <- function(id){
    if(is.null(id)){stop("You have to provide an id",call. = FALSE)}
}

#' Get connection to database
#' 
#' Will create the SQLite database if not found.
get_database_connection <- function(){
    DBI::dbConnect(RSQLite::SQLite(), "db.sqlite")
}

setup_database <- function(con){
    DBI::dbExecute(con, "PRAGMA foreign_keys = ON;")
    create_tokens_table(con)
    create_metadata_table(con)
    create_events_table(con)
    create_metrics_table(con)
    create_parameters_table(con)
}


create_tokens_table <- function(con){
    query = "CREATE TABLE IF NOT EXISTS tokens (
    ROWID INTEGER NOT NULL,
    label TEXT, 
    grouping TEXT,
    creationtime DATETIME NOT NULL DEFAULT (datetime('now','localtime')),
    PRIMARY KEY(ROWID)
    );"
    DBI::dbExecute(con, query)
}
create_metadata_table <-function(con){
    query = "CREATE TABLE IF NOT EXISTS metadata (
    id INTEGER REFERENCES tokens(ROWID),
    key TEXT NOT NULL,
    value TEXT,
    extra TEXT,
    creationtime DATETIME NOT NULL DEFAULT (datetime('now','localtime'))
    )"
    idx = "CREATE INDEX IF NOT EXISTS idx_metadata ON metadata(id);"
    DBI::dbExecute(con, query)
    DBI::dbExecute(con, idx)
}
create_events_table <-function(con){
    query = "CREATE TABLE IF NOT EXISTS events (
    id INTEGER REFERENCES tokens(ROWID),
    message TEXT NOT NULL,
    extra TEXT,
    creationtime DATETIME NOT NULL DEFAULT (datetime('now','localtime'))
    )"
    idx = "CREATE INDEX IF NOT EXISTS idx_events ON events(id);"
    DBI::dbExecute(con, query)
    DBI::dbExecute(con, idx)
} 

create_metrics_table <-function(con){
    query = "CREATE TABLE IF NOT EXISTS metrics (
    id INTEGER REFERENCES tokens(ROWID),
    metric TEXT NOT NULL,
    value REAL,
    extra TEXT,
    creationtime DATETIME NOT NULL DEFAULT (datetime('now','localtime'))
    )"
    idx = "CREATE INDEX IF NOT EXISTS idx_metrics ON metrics(id);"
    DBI::dbExecute(con, query)
    DBI::dbExecute(con, idx)
} 

create_parameters_table <-function(con){
    query = "CREATE TABLE IF NOT EXISTS parameters (
    id INTEGER REFERENCES tokens(ROWID),
    parameter TEXT NOT NULL,
    numeric REAL,
    text TEXT,
    extra TEXT,
    creationtime DATETIME NOT NULL DEFAULT (datetime('now','localtime'))
    )"
    idx = "CREATE INDEX IF NOT EXISTS idx_parameters ON parameters(id);"
    DBI::dbExecute(con, query)
    DBI::dbExecute(con, idx)
}

#' Register a new token
#' 
#' @param  con connection
#' @param label Label to use 
#' @param group Optional name of group
register_new_token <- function(con, label=NULL, group=NULL){
    # with transaction so the two actions are related.
    DBI::dbWithTransaction(con, {
        DBI::dbExecute(con, glue::glue_sql(
            "INSERT INTO tokens (label, grouping) VALUES ({label}, {group});", .con=con)) 
        res <- DBI::dbGetQuery(con, "select last_insert_rowid();")
    })
    res[[1]]
}

#' Send an event to the database
#' 
#' this will now return an error if the key does not exist.
#' Requires a valid token (id)
send_event <- function(con, id, message, extra=NULL){
    DBI::dbExecute(con, glue::glue_sql(
        "INSERT INTO events (id, message, extra) VALUES  ({id}, {message}, {extra});", .con=con))
}

#' Send an metric to the database
#' 
#' this will now return an error if the key does not exist.
send_metric <- function(con, id, metric, value, extra = NULL){
    DBI::dbExecute(con, glue::glue_sql(
        "INSERT INTO metrics (id, metric, value, extra) VALUES  ({id}, {metric}, {value},{extra});", .con=con))
}

#' Send parameters to database.
#' 
#' Requires a valid token (id)
send_parameters <- function(con, id, parameter, numeric=NULL, text=NULL, extra = NULL){
    DBI::dbExecute(con, glue::glue_sql(
        "INSERT INTO parameters (id, parameter, numeric, text, extra) VALUES  ({id}, {parameter}, {numeric}, {text}, {extra});", .con=con))
}

#' Send metadata to database.
#' 
#' Requires a valid token (id)
send_metadata <- function(con,id, key, value, extra=NULL){
    DBI::dbExecute(con, glue::glue_sql(
        "INSERT INTO metadata (id, key, value, extra) VALUES  ({id}, {key}, {value}, {extra});", .con=con))
}

nuke_database <- function(con){
    message("Deleting tables metrics, events, and tokens from db!")
    DBI::dbExecute(con, "drop table if exists metrics;")
    DBI::dbExecute(con, "drop table if exists events;")
    DBI::dbExecute(con, "drop table if exists parameters;")
    DBI::dbExecute(con, "drop table if exists metadata;")
    DBI::dbExecute(con, "drop table if exists tokens;")
}

show_table_sizes <- function(con){
    query = "
  select count(*) as rows, 'tokens' as tablename from tokens
  union
  select count(*) as rows, 'metrics' as tablename from metrics
  union
  select count(*) as rows, 'parameters' as tablename from parameters
  union 
  select count(*) as rows, 'metadata' as tablename from metadata
  union
  select count(*) as rows, 'events' as tablename from events
  "
    DBI::dbGetQuery(con, query)
}

con <- get_database_connection()
setup_database(con)

#* @apiTitle modelserver
#* @apiDescription This is an API server that you can use to send your model data to. Start by requesting an id via /new_run, you will need it for all other API endpoints, log your runs with events like start stop etc. to /events (using the id). Send metadat to /metadata, model parameters to /parameters and metrics to /metrics.
#* @apiVersion v1

#* Register new run.
#*
#* This will return a token (id) that you need for further requests.
#* @param label Modelserver will remember this label
#* @param group optional argument if you want to group runs
#* @get /new_run
function(label=NULL, group=NULL){
    res <- register_new_token(con, label, group)
    list(id = res)
}


#* Events endpoint
#* 
#* All run information is send here.
#* @param id required argument
#* @param message you want to send a message
#* @param extra can be empty
#* @post /events
function(res,id, message, extra=NULL){
    result <- 
        handle_foreignkey_error(
        send_event(con, id, message, extra),
        res)
    res <- result$res
    list(result$msg)
}

#* Metadata endpoint
#* 
#* Send metadata about a run to the backend. 
#* Use key-value combinations
#* For instance: "title" , "a nice title" or "author", "simply red" 
#* or "model", "XGBoost"
#* @param id required argument
#* @param key text field
#* @param value text field
#* @param extra optional extra field
#* @post /metadata
function(res,id, key, value, extra=NULL){
    result <- 
        handle_foreignkey_error(
            send_metadata(con, id, key, value, extra),
            res)
    res <- result$res
    list(result$msg)
}


#* Metrics endpoint
#* 
#* Send metrics about your run to the backend.
#* use key value
#* For instance: "RMSE", 0.87
#* @param id required argument
#* @param metric Name of the metric
#* @param value:dbl numeric value for metric
#* @param extra optional extra field
#* @post /metrics
function(res,id, metric, value, extra=NULL){
    result <- 
        handle_foreignkey_error(
            send_metric(con, id, metric, value, extra),
            res)
    res <- result$res
    list(result$msg)
}

#* Parameter endpoint
#*
#* Send parameters to the backend.
#* These can be numeric or textual 
#* For instance "n_trees", 4, NULL or "mode", NULL, "regression"
#* @param id required argument
#* @param parameter name of the parameter
#* @param numeric:dbl optional numeric value for parameter
#* @param text optional text value for parameter
#* @param extra optional extra field
#* @post /parameters
function(res,id, parameter, numeric = NULL, text=NULL, extra=NULL){
    result <- 
        handle_foreignkey_error(
            send_parameters(con, id, parameter, numeric, text, extra),
            res)
    res <- result$res
    list(result$msg)
}


#' Get status
#' 
#' Returns the number of rows in database.
#' @get /status
function(){
    list(show_table_sizes(con))
}


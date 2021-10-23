con <- get_database_connection()
setup_database(con)

#* Register new run.
#*
#* This will return a token that you need for further requests.
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
function(id, message, extra=NULL){
    fail_on_missing_id(id)
    send_event(con, id, message, extra)
    list("response saved")
}

#* Metadata endpoint
#* 
#* Send metadata about a run to the backend. 
#* Use key-value combinations
#* For instance: "title" , "a nice title" or "author", "simply red" 
#* or "model", "XGBoost"
#* @param id required argument
#* @param key 
#* @param value
#* @param extra 
#* @post /metadata
function(id, key, value, extra=NULL){
    fail_on_missing_id(id)
    send_metadata(con, id, key, value, extra)
    list("response saved")
}


#* Metrics endpoint
#* 
#* Send metrics about your run to the backend.
#* use key value
#* For instance: "RMSE", 0.87
#* @param 
#* @post /metrics
function(id, metric, value, extra=NULL){
    fail_on_missing_id(id)
    send_metric(con, id, metric, value, extra)
    list("metric saved")
}

#* Parameter endpoint
#*
#* Send parameters to the backend.
#* These can be numeric or textual 
#* For instance "n_trees", 4, NULL or "mode", NULL, "regression"
#* @param id
#* @param parameter
#* @post /parameters
function(id, parameter, numeric = NULL, text=NULL, extra=NULL){
    fail_on_missing_id(id)
    send_parameters(con, id, parameter, numeric, text, extra)
    list("parameter saved")
}

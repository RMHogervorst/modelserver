con <- get_database_connection()


#* Register new run.
#*
#* This will return a token that you need for further requests.
#* @param label Modelserver will remember this label
#* @param group optional argument if you want to group runs
#* @get /new_run
function(label, group=NULL){
    list(register_new_token(label,group, con))
}


#* Runs endpoint
#* 
#* All run information is send here
#* @param token required argument
#* @param message 
#* @post /runs
function(id = NULL, message){
    
}

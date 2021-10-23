# A server for machine learning analytics.
[![Active Repository](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![licence MIT](https://img.shields.io/github/license/mashape/apistatus.svg)](https://choosealicense.com/licenses/mit/)
![](https://img.shields.io/static/v1?label=Progress&message=WIP&color=yellow&style=plastic)
The idea is you send a request when you start a run and when you end a run and in between you send metrics to the server. 

The server handles these things and puts them into a database. 
(this is inspired by the MLflow python package that does this and more) I think this is most like MLFlow - Tracking.


## How to run
Right now, clone this repo somewhere.
In the commandline go to this somewhere.
Start R in that location. run `renv::restore()`
move out of R.
In the terminal run the command `Rscript run_server.R`

## Comparison with MLFlow
MLFlow uses runs and experiments. A run is an execution of code.
multple runs live under 1 experiment.
A run also includes timing.

_wow they improved the docs a lot in the past years! I love it, it is much easeir to understand._

So I did the same thing, but named it differently. I have ids for runs and optional group to combine several.

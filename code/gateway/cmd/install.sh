#!/bin/bash -e
##-------------------------------------------------------------------
## File : install.sh
## Description :
## --
## Created : <2014-01-17>
## Updated: Time-stamp: <2014-01-17 16:25:12>
##-------------------------------------------------------------------
source /etc/profile # TODO, remove this workaround
. $PROP_HOME/cmd/utility.sh

mongo_port=27017

log "setup mongo db"
mongo localhost:$mongo_port/dataplatform ../mongo/create_index.js

## File : install.sh ends

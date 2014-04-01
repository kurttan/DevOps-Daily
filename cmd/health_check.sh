#!/bin/bash -e
##-------------------------------------------------------------------
## File : health_check.sh
## Description :
## --
## Created : <2014-01-11>
## Updated: Time-stamp: <2014-02-19 01:23:58>
##-------------------------------------------------------------------
. utility.sh
source /etc/profile # TODO

log "Check service running"
sudo lsof -i tcp:55672 || sudo lsof -i tcp:5672 || exit_error "Rabbitmq is not running"
sudo lsof -i tcp:$PORT_GATEWAY || exit_error "Gateway service is not running"

## File : health_check.sh ends

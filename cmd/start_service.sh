#!/bin/bash -e
##-------------------------------------------------------------------
## File : start_service.sh
## Description :
## --
## Created : <2013-12-29>
## Updated: Time-stamp: <2014-01-17 16:32:44>
##-------------------------------------------------------------------
. utility.sh
source /etc/profile # TODO

function start_rabbitmq ()
{
    log "start rabbitmq"
    sudo lsof -i tcp:55672 || nohup sudo rabbitmq-server start &
}

function start_gateway ()
{
    log "start gateway"
    lsof -i tcp:$PORT_GATEWAY || (cd $PROP_HOME/code/gateway && make start)
}


start_rabbitmq
start_gateway

## File : start_service.sh ends

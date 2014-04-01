#!/bin/bash -e
##-------------------------------------------------------------------
## File : upgrade.sh
## Description :
## --
## Created : <2013-12-29>
## Updated: Time-stamp: <2014-01-13 14:24:34>
##-------------------------------------------------------------------
. utility.sh
source /etc/profile # TODO
function update_git ()
{
    cd $PROP_HOME
    git pull origin denny
}

ensure_variable_isset "$PROP_HOME" "PROP_HOME"
update_git

## File : upgrade.sh ends

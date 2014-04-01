#!/bin/bash
##-------------------------------------------------------------------
## @copyright 2014
## File : mongo_index.sh
## Description :
## --
## Created : <2014-01-17>
## Updated: Time-stamp: <2014-01-30 10:06:26>
##-------------------------------------------------------------------
# sh ./mongo_run_js.sh
# 0 3 * * * source /etc/profile; cd /home/zhangwei/omnisale_metaindex; /home/zhangwei/omnisale_metaindex/mongo_index.sh >> /var/log/mongo_index.log
function log() {
    local msg=${1?}
    echo -ne `date +['%Y-%m-%d %H:%M:%S']`" $msg\n"
}
export PATH="/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin"
# TODO
#yesterday=`date "+%Y-%m-%d" --date="1 days ago"`

function update_day() {
    day=${1?}
    mongo_port=${2?}
    # TODO
    file="media.js"
    log "update index for $file\n"
    mongo --eval "var day='$day'" localhost:$mongo_port/dataplatform ../mongo/js/$file

    file="manufacture.js"
    log "update index for $file\n"
    mongo --eval "var day='$day'" localhost:$mongo_port/dataplatform ../mongo/js/$file

    file="resturant.js"
    log "update index for $file\n"
    mongo --eval "var day='$day'" localhost:$mongo_port/dataplatform ../mongo/js/$file

}

mongo_port1=27017
day=${1?}
log "Update index for $day."
update_day $day $mongo_port1

log "Script completed in $SECONDS seconds"


# mongo_port2=27018

# log "Export index collection of mongo ${mongo_port1} to /tmp/index_${yesterday}.json"
# mongoexport --db shopex --collection index -q "{'day':'$yesterday'}" --port $mongo_port1 --out /tmp/index_${yesterday}.json

# log "Import index collection of /tmp/index_${yesterday}.json to mongo {mongo_port2}"
# mongoimport --upsert --db shopex --collection index --port $mongo_port2 --file /tmp/index_${yesterday}.json

## File : mongo_index.sh ends

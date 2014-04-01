#!/bin/bash -e
##-------------------------------------------------------------------
## File : tests.sh
## Description :
## --
## Created : <2014-01-13>
## Updated: Time-stamp: <2014-01-30 13:07:51>
##-------------------------------------------------------------------
source /etc/profile # TODO, remove this workaround
. $PROP_HOME/cmd/utility.sh

#post_header="-H \"Content-type: application/json\""
post_header=""

function clean(){
    table_list="media_action media_index manufacture_product manufacture_index restaurant_expense restaurant_index"
    for table in ${table_list[*]}; do
        log "remove mongo table of ${table}"
        mongo --eval "db.${table}.drop()" localhost:27017/dataplatform
    done
}

function media_test () {
    log "insert records media_customer table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'media', 'table':'customer', 'storeID': '02414', 'data':{'customerID':'0023', 'customerAge':'20', 'customerSex':'男', 'customerArea':'上海', 'customerPhone':'18621908421'}}" "$post_header"

    log "insert records media_action table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'media', 'table':'action', 'storeID': '02414', 'data':{'pageID':'0234145', 'actionType':'enter', 'pageVisitTime':'2014-01-13 17:08:00', 'pageVisitType':'是', 'customerVisitWay':'手机', 'customerID':'0023', 'customerDevice':'Andorid'}}" "$post_header"

    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'media', 'table':'action', 'storeID': '02414', 'data':{'pageID':'0234143', 'actionType':'enter', 'pageVisitTime':'2014-01-13 17:08:00', 'pageVisitType':'是', 'customerVisitWay':'手机', 'customerID':'0023', 'customerDevice':'Andorid'}}" "$post_header"

    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'media', 'table':'action', 'storeID': '02414', 'data':{'pageID':'0234143', 'actionType':'comment', 'pageVisitTime':'2014-01-13 17:08:00', 'pageVisitType':'是', 'customerVisitWay':'手机', 'customerID':'0023', 'customerDevice':'Andorid'}}" "$post_header"


    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'media', 'table':'action', 'storeID': '02414', 'data':{'pageID':'0234145', 'actionType':'collect', 'pageVisitTime':'2014-01-13 17:08:00', 'pageVisitType':'是', 'customerVisitWay':'手机', 'customerID':'0023', 'customerDevice':'Andorid'}}" "$post_header"

    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'media', 'table':'action', 'storeID': '02414', 'data':{'pageID':'0234146', 'actionType':'comment', 'pageVisitTime':'2014-01-13 17:08:00', 'pageVisitType':'是', 'customerVisitWay':'手机', 'customerID':'0023', 'customerDevice':'Andorid'}}" "$post_header"

    log "list index of media_index table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/list_index "{'industry':'media', 'storeID':'02414'}" "$post_header"

    log "query index of media_index table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/query_index "{'industry':'media', 'storeID':'02414', 'key':'pageVisitCount', 'para_list':{'pageID':'0234143'}}" "$post_header"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/query_index "{'industry':'media', 'storeID':'02414', 'key':'pageCommentCount', 'para_list':{'pageID':'0234143'}}" "$post_header"

    log "query record count of media_action table"
    mongo --eval "db.media_action.count()" localhost:27017/dataplatform
    echo ""
}

function manufacture_test () {
    log "insert records manufacture_product table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'manufacture', 'table':'product', 'storeID': '02414', 'data':{'productID':'0234143','customerAge':23,'consumeArea':'上海','customerPhone':'18621908482','consumeWay':'直售','firstFixTime':'2014-01-12','productType':'车上贴膜','fixProduct':'轮胎','fixProductSeller':'002','fixProductBatches':'002', 'manufacturer':'北方制造'}}" "$post_header"

    log "list index of manufacture_index table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/list_index "{'industry':'manufacture', 'storeID':'02414'}" "$post_header"

    log "query index of manufacture_index table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/query_index "{'industry':'manufacture', 'storeID':'02414', 'key':'hotSeller', 'para_list':{}}" "$post_header"

    log "query record count of manufacture_product table"
    mongo --eval "db.manufacture_product.count()" localhost:27017/dataplatform
    echo ""
}

function restaurant_test () {
    log "insert records restaurant_customer table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/insert_data "{'industry':'restaurant', 'table':'expense', 'storeID': '02414', 'data':{'customerID':'0234143','customerType':'团体','consumePrice':50.3,'customerFrom':'朋友介绍','checkoutType':'现金','dishCount':5,'checkoutType':'刷卡','customerAge':30,'drinkConsume':50,'stayTime':40,'drinkingTime':'晚餐','complaints':'###'}}" "$post_header"

    log "list index of restaurant_index table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/list_index "{'industry':'restaurant', 'storeID':'02414'}" "$post_header"

    log "query index of restaurant_index table"
    request_url_post http://127.0.0.1:$PORT_GATEWAY/query_index "{'industry':'restaurant', 'storeID':'02414', 'key':'pushInfo', 'para_list':{'customerID':'0234143'}}" "$post_header"

    log "query record count of restaurant_expense table"
    mongo --eval "db.restaurant_expense.count()" localhost:27017/dataplatform
    echo ""
}

function all() {
    media_test
    manufacture_test
    restaurant_test
}

fun_name=${1?}
$fun_name

## File : tests.sh ends

//-------------------------------------------------------------------
// @copyright 2014
// File : media.js
// Description : Caculate users' indexes
// Created : <2014-01-17>
// Updated: Time-stamp: <2014-01-30 10:10:01>
//-------------------------------------------------------------------

// mongo --eval "var day='2013-08-02'" localhost:27017/dataplatform mongo_js/user_index.js

//var day='2014-01-26'
var start_seconds=db.eval("dayToSeconds('"+day+"')");
var end_seconds=start_seconds+86400;
var caculate_seconds=3600*24;

var storeID_list = db.media_action.distinct("storeID", {"extra_mongo_createtime":{$gte:start_seconds,$lt:end_seconds}})

function fun1() {
    index_list = ["pageVisitCount", "pageCommentCount", "pageCollectCount"]
    actionType_list = ["enter", "comment", "collect"]
    for(k=0; k<index_list.length; k++) {
        index_name = index_list[k]
        printjson("[" + new Date() + "] get index: " + index_name);
        seconds1=start_seconds
        while(seconds1<end_seconds){
            seconds2=seconds1+caculate_seconds
            i=0;
            while(i<storeID_list.length) {
                storeID=storeID_list[i++];
                // TODO: If memory still takes over 16MB for a given store, query mongo in map-reduce way
                s = db.media_action.aggregate(
                    {$match:{"extra_mongo_createtime":{$gte:seconds1,$lt:seconds2},
                             "storeID":storeID, "actionType":actionType_list[k]}},
                    {$group:{
                        _id:{pageID:"$pageID"},
                        value:{$sum:1}
                    }}
                );

                result=s["result"];
                j=0;
                while(j<result.length) {
                    pageID=result[j]._id.pageID;
                    value = result[j].value

                    db.media_index.save({"_id":hex_md5(index_name+storeID+pageID+seconds1),
                                         "name":index_name,"storeID":storeID, "pageID":pageID,
                                         "value":value, "modifiedtime":new Date()});

                    j+=1;
                }
            }
            seconds1+=caculate_seconds
        }
    }
}

///================================================================
fun1(); // get index pageVisitCount, pageCommentCount, pageCollectCount
///================================================================
// File : media.js ends
//-------------------------------------------------------------------
// @copyright 2013
// File : create_index.js
// Description : Create mongo indexes
// Created : <2014-01-17>
// Updated: Time-stamp: <2014-02-02 09:02:03>
//-------------------------------------------------------------------

//#######################################################
// set ttl index for mongo:27017
//use dataplatform;

// TODO: remove code code duplication
printjson("create index");
db.media_action.dropIndexes();
db.media_action.ensureIndex({"storeID":1});
db.media_action.ensureIndex({"extra_mongo_createtime":1}, {expireAfterSeconds:3*24*60*60});

db.media_index.dropIndexes();
db.media_index.ensureIndex({"name":1});
db.media_index.ensureIndex({"storeID":1});

db.manufacture_product.dropIndexes();
db.manufacture_product.ensureIndex({"storeID":1});
db.manufacture_product.ensureIndex({"extra_mongo_createtime":1}, {expireAfterSeconds:3*24*60*60});

db.manufacture_index.dropIndexes();
db.manufacture_index.ensureIndex({"name":1});
db.manufacture_index.ensureIndex({"storeID":1});

db.restaurant_expense.dropIndexes();
db.restaurant_expense.ensureIndex({"storeID":1});
db.restaurant_expense.ensureIndex({"extra_mongo_createtime":1}, {expireAfterSeconds:3*24*60*60});

db.restaurant_index.dropIndexes();
db.restaurant_index.ensureIndex({"name":1});
db.restaurant_index.ensureIndex({"storeID":1});

// TODO: automate below
// install function
db.system.js.save({_id:"dayToSeconds", value:function(day)
                   {var date = new Date(day+" 00:00:00"); return parseInt(date.getTime()/1000);}});

//#######################################################

// File : create_index.js ends

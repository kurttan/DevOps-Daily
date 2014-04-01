# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2014
## File : server.py
## Description :
## --
## Created : <2014-01-13 00:00:00>
## Updated: Time-stamp: <2014-02-19 00:34:34>
##-------------------------------------------------------------------
import os
from flask import Flask, request, make_response
from flask import render_template
from flask import url_for, redirect, send_file

import json
import datetime
import time
import pymongo

from util import log, get_mongo_table
from util import format_record, smarty_remove_extra_comma
from config import *
from exception import DataPlatformException

mongo_conn=None

import sys
default_encoding = 'utf-8'
if sys.getdefaultencoding() != default_encoding:
    reload(sys)
    sys.setdefaultencoding(default_encoding)

app = Flask(__name__)

################# public backend api ###########################
@app.route("/insert_data", methods=['POST'])
def insert_data():
    mycontent = myContent("error")
    with watched(mycontent):
        data = _parse_post_json(request)
        json_obj=json.loads(data)
        (industry, table, storeID, data) = _parse_insert_data(json_obj)
        send_to_mongo(industry, table, data)

        mycontent.message = render_template('insert_data.json', status="ok", errmsg="ok")

    resp = make_response(mycontent.message, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/list_index", methods=['POST'])
def list_index():
    mycontent = myContent("error")
    with watched(mycontent):
        data = _parse_post_json(request)

        json_obj=json.loads(data)

        industry = json_obj["industry"]
        storeID = json_obj["storeID"]

        mycontent.message = _list_index(industry, storeID)

    resp = make_response(mycontent.message, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/query_index", methods=['POST'])
def query_index():
    mycontent = myContent("error")
    with watched(mycontent):
        data = _parse_post_json(request)

        json_obj=json.loads(data)

        (industry, storeID, key, para_list) = _parse_query_index(json_obj)

        # TODO
        if len(para_list) != 1:
            raise DataPlatformException("query_index fail: length of para_list should be 1: %s" % (para_list))

        mycontent.message = _query_index(industry, storeID, key, para_list.values()[0])

    resp = make_response(mycontent.message, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

## bypass cross domain security
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*') # TODO: to be more secured
    response.headers.add('Access-Control-Allow-Methods', 'GET')
    response.headers.add('Access-Control-Allow-Methods', 'POST')
    response.headers.add('Access-Control-Allow-Headers', 'X-Requested-With')
    return response

################################################################
def _parse_insert_data(json_obj):
    industry = json_obj["industry"]
    table = json_obj["table"]
    data = json_obj["data"]
    storeID = json_obj["storeID"]
    data["storeID"] = storeID # TODO

    return (industry, table, storeID, data)

def _parse_query_index(json_obj):
    industry = json_obj["industry"]
    storeID = json_obj["storeID"]
    key = json_obj["key"]
    para_list = json_obj["para_list"]
    return (industry, storeID, key, para_list)

def _parse_post_json(request):
    if sys.platform == "linux2":
        dict_a=dict(request.form)

        return dict_a.keys()[0]

    if sys.platform == "darwin":
        return request.data

    raise DataPlatformException("_parse_post_json error: Unsupported platform(%s)" % (sys.platform))
    return None

def _list_index(industry, storeID):
    table_name = get_mongo_tablename(industry, "index")
    table = mongo_conn.dataplatform[doc_name]

    index_list = table.find( {"storeID":storeID}).distinct("name")
    index_str = ', '.join(map(lambda x: "\"%s\"" % x, index_list))
    content = render_template('list_index.json', index_str=index_str)
    content = smarty_remove_extra_comma(content)
    return content

def _query_index(industry, storeID, key, para1):
    collection = mongo_conn.dataplatform
    table_name = get_mongo_table(industry, "index")
    table = collection[table_name]
    key_name = 'pageID' # TODO
        
    # TODO
    pipeline = [{'$match':{'storeID':storeID, key_name:para1, 'name':key}},
                {'$group':{'_id':'$'+key_name,'value':{'$sum':'$value'}}}]

    json_data = collection.command('aggregate', table_name, pipeline=pipeline)
    result = json_data['result']

    if len(result) != 1:
        status = "error"
        value = "-1"
    else:
        status = "ok"
        value = result[0]['value']

    content = render_template('query_index.json', status=status, value=value)
    content = smarty_remove_extra_comma(content)
    return content

def get_mongo_conn():
    global mongo_conn
    mongo_conn = pymongo.Connection(MONGO_HOST, MONGO_PORT)
    return mongo_conn

def send_to_mongo(industry, table, data):
    print "send_to_mongo"
    #msg_dict = eval(msg)
    global mongo_conn

    table_name = get_mongo_table(industry, table)
    table = mongo_conn.dataplatform[table_name]

    #print msg_dict

    new_dict = format_record(data)

    # new_dict["_id"] = get_object_id(data_dict) # TODO
    #new_dict[TTL_FIELD] = datetime.datetime.utcnow()
    new_dict[TTL_FIELD] = int(round(time.time()))

    print new_dict

    table.save(new_dict)
    return True

################################################################
class myContent:
    def __init__(self, message):
        self.message = message

from contextlib import contextmanager
@contextmanager
def watched(mycontent):
    try:
        yield mycontent
    except Exception, e :
        mycontent.message = render_template('error.json', status="error", errmsg=e.message)
################################################################

if __name__ == "__main__":
    app.debug = True
    #port=os.getenv("PORT_GATEWAY") # TODO
    mongo_conn = get_mongo_conn()
    port=8810
    app.run(host="0.0.0.0", port = int(port))
## File : server.py

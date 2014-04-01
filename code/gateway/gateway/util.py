# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013 UnitedStack Co,.Ltd
## File : util.py
## Description :
## --
## Created : <2014-01-16>
## Updated: Time-stamp: <2014-01-30 15:13:28>
##-------------------------------------------------------------------
from logging.handlers import RotatingFileHandler
import logging
import sys
from exception import DataPlatformException

format = "%(asctime)s %(filename)s:%(lineno)d - %(levelname)s: %(message)s"
formatter = logging.Formatter(format)

log = logging.getLogger('myapp')

Rthandler = RotatingFileHandler('prop_analysis.log', maxBytes=5*1024*1024,backupCount=5)
Rthandler.setLevel(logging.INFO)
Rthandler.setFormatter(formatter)

consoleHandler = logging.StreamHandler()
consoleHandler.setLevel(logging.INFO)
consoleHandler.setFormatter(formatter)

log.setLevel(logging.INFO)
#log.setLevel(logging.WARNING)
log.addHandler(consoleHandler)
log.addHandler(Rthandler)

def format_record(msg_dict):
    # TODO logic related
    return msg_dict

def smarty_remove_extra_comma(content):
    if content[-2] == ',':
        content = content[0:-2] + content[-1]
    return content

def get_mongo_table(industry, table):
    # TODO: logic related
    if industry not in ['media', 'manufacture', 'restaurant']:
        raise DataPlatformException("get_mongo_table fail: invalid industry name(%s)" % (industry))

    if table not in ['action', 'expense', 'product', 'index']:
        raise DataPlatformException("get_mongo_table fail: invalid table name(%s)" % (table))

    return "%s_%s" % (industry, table)

## File : util.py ends

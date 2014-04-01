# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013 UnitedStack Co,.Ltd
## File : exception.py
## Description :
## --
## Created : <2014-01-30>
## Updated: Time-stamp: <2014-01-30 13:37:50>
##-------------------------------------------------------------------

class DataPlatformException(Exception):
    message = "An unknown exception occurred"

    def __init__(self, message):
        self.message = message

    def __str__(self):
        return repr(self.message)

## File : exception.py ends

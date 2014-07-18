#!/usr/bin/python
#-*-coding:utf-8-*-

import httplib
import urllib
import json
import logging

log = logging.getLogger(__name__)

# Define the module's virtual name
__virtualname__ = 'spirit'

def __virtual__():
    return __virtualname__

def returner(ret):
    '''
    Return information to spirit http server on port 2551
    '''
    log.debug("/job/%(id)s/%(jid)s/%(return)s" % ret)
    
    httpClient = None
    try:
        pillar_data = __salt__['pillar.raw']()
        pillar = None
        grains = None

        if (('spirit' in pillar_data) and ('resultDetail' in pillar_data['spirit'])):
            if pillar_data['spirit']['resultDetail']:
                pillar = pillar_data
                grains = __salt__['grains.items']()

        data = {
            'result': ret,
            'pillar': pillar,
            'grains': grains
        }
        
        headers = {"Content-type": "application/json"  
                        , "Accept": "text/plain"}  
        
        httpClient = httplib.HTTPConnection("192.168.59.3", 2551, timeout=30)  
        httpClient.request("POST", "/job/%(jid)s/%(id)s" % ret, json.dumps(data), headers)  
        
        response = httpClient.getresponse()

        print response.status
        print response.reason
        print response.read()
        print response.getheaders() #获取头信息  
    except Exception, e:  
        log.error(str(e))
    finally:  
        if httpClient:  
            httpClient.close()

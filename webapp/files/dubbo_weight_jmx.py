#!/usr/bin/env python
# -*- coding: utf-8 -*-
# from requests.auth import HTTPBasicAuth
# import requests
import time
import socket
import os
import sys
import sched, time
import commands
import urllib


class cmd(object):
    def __init__(self, maxInvoke, interval, timeout):
        self.maxInvoke = maxInvoke
        self.interval = interval
        self.timeout = timeout

    def cmdInterval(self):
        maxExecuteTimes = (self.timeout + self.interval -1) / self.interval
        (ret, invokeNum) = self.cmdExecute()
        print("execute result %r, %d. max execute %d" % (ret, invokeNum, maxExecuteTimes))
        if (ret):
            executeTime = 0
            while (executeTime < maxExecuteTimes):
                if (invokeNum < self.maxInvoke):
                    return True
                time.sleep(self.interval)
                (ret, invokeNum) = self.cmdExecute()
                if (not ret):
                    return False
                executeTime += 1
                print("wait %d times, invoke num %d" % (executeTime, invokeNum))

            print("dubbo thread num is %d" % invokeNum)
            return False
        else:
            time.sleep(self.timeout)
            return True

    def cmdExecute(self):
        try:
            (eventStatus, eventResult) = commands.getstatusoutput('java -jar /home/tomcat/cmdline-jmxclient-0.10.3.jar - 127.0.0.1:9000 com.qianmi:name=DubboInvokeMBean AliveProviderEvents')
            eventStatus >>= 8
            eventResult = eventResult[eventResult.rfind(':') + 1:]
            if(eventStatus != 0):
                return (False, 0)
            else:
                try:
                    return (True, int(eventResult))
                except:
                    print "except error: DubboInvokeMBean is not a registered bean"
                    return (False, 0)
        except:
            print "Unexpected error:", sys.exc_info()[0]
            return (False, 0)

#dubbo服务
class dubbo(object):
    def __init__(self, monitor, user, pwd, provider, weight):
        self.monitor = monitor
        self.user = user
        self.pwd = pwd
        self.provider = provider
        self.weight = str(weight)

        self.boolean_true = u'操作成功'
        self.boolean_false = 'dubbo execute false'
        self.boolean_noProvider = 'there is no provider'

    def operatorFun(self):
        opeUrl = 'http://'+self.user+':'+self.pwd+'@'+self.monitor+'/governance/addresses/'+self.provider+'/providers/weight?weight=' + self.weight
        print opeUrl
        try:
            r_ope = urllib.urlopen(opeUrl)
            text = r_ope.read().decode('utf-8')
            # print text

            int_result = text.find(self.boolean_true)
            # print int_result
            if int_result == -1:
                if(text.find(self.boolean_noProvider) != -1):
                    print self.boolean_noProvider
                    # raise Exception(self.boolean_noProvider)
                else:
                    raise Exception(self.boolean_false)
            else :
                print self.boolean_true.encode('utf-8')
                return True
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise

if __name__ == "__main__":
    if(len(sys.argv) != 5):
        errorStr = "您需要传递4个参数，格式为：python dubbo_weight.py dubboadmin:port adminUser adminPassword weight;\n 1、dubboadmin:port(dubboadmin应用暴露的服务),2、adminUser(dubboadmin登录用户),3、adminPassword(dubboadmin登录密码),4、weight(权重)"
        print errorStr
        raise Exception(errorStr)
    else:
        print(sys.argv[0])
        dubboadmin = sys.argv[1]
        print(dubboadmin)
        adminUser = sys.argv[2]
        print(adminUser)
        adminPassword = sys.argv[3]
        print(adminPassword)
        weight = sys.argv[4]
        print(weight)

        myname = socket.getfqdn(socket.gethostname())
        print(myname)
        myaddr = socket.gethostbyname(myname)
        print(myaddr)

        # dubboadmin = "172.19.65.13:8080"
        # adminUser = "root"
        # adminPassword = "master123"    
        # myaddr = "172.19.65.22"
        # weight = 0
        try:
            dubbo(dubboadmin, adminUser, adminPassword, myaddr+':', weight).operatorFun()
            if(int(weight) == 0):
                if not cmd(1, 3, 30).cmdInterval():
                    raise Exception("cmd execute exception")
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise
        # return cmdResult

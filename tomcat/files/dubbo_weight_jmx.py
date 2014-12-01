#!/usr/bin/env python
# -*- coding: utf-8 -*-
from requests.auth import HTTPBasicAuth
import requests
import time
import socket
import os
import sys
import sched, time
import commands


class cmd(object):
    def __init__(self, maxEvent, interval, timeout):
        self.maxEvent = maxEvent
        self.event = 1000
        self.executeTimes = 0
        self.interval = interval
        self.timeout = timeout
        self.s = sched.scheduler(time.time, time.sleep)


    def cmdInterval(self):
        self.maxExecuteTimes = (self.timeout / self.interval) + 1
        print(self.maxExecuteTimes)
        if(self.event > self.maxEvent and self.executeTimes < self.maxExecuteTimes):
            print(self.executeTimes)
            self.s.enter(5, 1, self.cmdExecute, ())
            self.s.run()

        elif(self.event > self.maxEvent):
            print('dubbo thread num is too much ' + str(self.event) + '; time is ' + str(self.executeTimes * self.interval))
            raise Exception('dubbo thread num is too much ' + str(self.event) + '; time is ' + str(self.executeTimes * self.interval))
        else:
            print('dubbo thread num is ' + str(self.event) + '; time is ' + str(self.executeTimes * self.interval))
            return True

    def cmdExecute(self):
        try:
            (eventStatus, self.event) = commands.getstatusoutput('java -jar /home/tomcat/cmdline-jmxclient-0.10.3.jar - 127.0.0.1:9000 com.qianmi:name=DubboInvokeMBean AliveProviderEvents')
            eventStatus >>= 8
            self.event = self.event[self.event.rfind(':') + 1:]
            if(eventStatus == 1):
                raise Exception(self.event)
            else:
                self.event = int(self.event)
            print('result is ' + str(self.event))
            self.executeTimes = self.executeTimes + 1
            self.cmdInterval()
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise

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
        #拼接url，批量禁用providers
        # opeUrl = 'http://'+self.monitor+'/governance/addresses/'+self.provider+'/providers/'+str(0.6)+'/weight?weight=0.5'
        opeUrl = 'http://'+self.monitor+'/governance/addresses/'+self.provider+'/providers/weight?weight=' + self.weight
        print opeUrl
        try:
            r_ope = requests.get(opeUrl,auth=HTTPBasicAuth(self.user, self.pwd))
            # print r_ope.text
            

            int_result = r_ope.text.find(self.boolean_true)
            # print int_result
            if int_result == -1:
                if(r_ope.text.find(self.boolean_noProvider) != -1):
                    print self.boolean_noProvider
                    raise Exception(self.boolean_noProvider)
                else:
                    raise Exception(self.boolean_false)
            else :
                print self.boolean_true.encode('utf-8')
                return True
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise
        

if __name__ == "__main__":
    if(len(sys.argv) != 6):
        errorStr = "您需要传递5个参数，格式为：python dubbo_weight.py dubboadmin:port adminUser adminPassword providerPort weight;\n 1、dubboadmin:port(dubboadmin应用暴露的服务),2、adminUser(dubboadmin登录用户),3、adminPassword(dubboadmin登录密码),4、providerPort(应用的dubbo端口),5、weight(权重)"
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
        providerPort = int(sys.argv[4])
        print(providerPort)
        weight = sys.argv[5]
        print(weight)

        myname = socket.getfqdn(socket.gethostname())
        print(myname)
        myaddr = socket.gethostbyname(myname)
        print(myaddr)

        # dubboadmin = "172.19.65.13:8080"
        # adminUser = "root"
        # adminPassword = "master123"    
        # myaddr = "172.19.65.22"
        # providerPort = 20882
        # weight = 0
        try:
            dubbo(dubboadmin, adminUser, adminPassword, myaddr+':'+str(providerPort), weight).operatorFun()
            cmdResult = cmd(1, 3, 30).cmdInterval()
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise
        # return cmdResult
            
            
    




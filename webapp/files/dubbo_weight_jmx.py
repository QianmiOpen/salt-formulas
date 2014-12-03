#!/usr/bin/env python
# -*- coding: utf-8 -*-
import socket
import sys
import commands
import urllib
import time

class cmd(object):
    CONNECT_REFUSED = "Connection refused"

    JMX_OK = 0
    JMX_CONNECT_REFUSED = 1
    JMX_ERROR = 2

    def check_app_start(self, interval, timeout):
        jmx_name = "com.ofpay.health:name=HealthStatus"
        jxm_attr = "Started"
        max_execute_times = (timeout + interval - 1) / interval
        (ret, started) = self.get_jmx(jmx_name, jxm_attr, lambda x: "true" in x.lower(), False)
        print("execute result %r, %r. max execute %d." % (ret, started, max_execute_times))
        if ret == cmd.JMX_OK:
            execute_time = 0
            while (execute_time < max_execute_times):
                if (started):
                    return True
                time.sleep(interval)
                (ret, started) = self.get_jmx(jmx_name, jxm_attr, lambda x: "true" in x.lower(), False)
                if (ret != cmd.JMX_OK):
                    return False
                execute_time += 1
                print("wait %d times, is started: %r" % (execute_time, started))

            return False
        elif ret == cmd.JMX_ERROR:
            time.sleep(timeout)
            return True

    def check_dubbo_stop(self, max_invoke, interval, timeout):
        jmx_name = "com.qianmi:name=DubboProviderMBean"
        jxm_attr = "AliveEvents"
        max_execute_times = (timeout + interval - 1) / interval
        (ret, invoke_num) = self.get_jmx(jmx_name, jxm_attr, int, 0)
        print("execute result %r, %d. max execute %d" % (ret, invoke_num, max_execute_times))
        if ret == cmd.JMX_OK:
            execute_time = 0
            while (execute_time < max_execute_times):
                if (invoke_num < max_invoke):
                    return True
                time.sleep(interval)
                (ret, invoke_num) = self.get_jmx(jmx_name, jxm_attr, int, 0)
                if (ret != cmd.JMX_OK):
                    return False
                execute_time += 1
                print("wait %d times, invoke num %d" % (execute_time, invoke_num))

            return False
        elif ret == cmd.JMX_ERROR:
            time.sleep(timeout)
            return True

    def get_jmx(self, name, attr, retTrans, default = "0"):
        try:
            (event_status, event_result) = commands.getstatusoutput("java -jar /home/tomcat/cmdline-jmxclient-0.10.3.jar - 127.0.0.1:9000 %s %s" % (name, attr))
            print "jmx result: %d, %s" % (event_status, event_result)
            event_status >>= 8
            if(event_status != 0):
                if cmd.CONNECT_REFUSED in event_result:
                    return (cmd.JMX_CONNECT_REFUSED, default)
                else:
                    return (cmd.JMX_ERROR, default)
            else:
                try:
                    event_result = event_result[event_result.rfind(':') + 1:]
                    return (cmd.JMX_OK, retTrans(event_result))
                except:
                    print "except error: DubboInvokeMBean is not a registered bean"
                    return (cmd.JMX_ERROR, default)
        except:
            print "Unexpected error:", sys.exc_info()[0]
            return (cmd.JMX_ERROR, default)

class dubbo(object):
    SUCCESS = u'操作成功'
    NO_PROVIDER = 'there is no provider'

    RET_OK = 0
    RET_NO_PROVIDER = 1
    RET_ERROR = 2

    def set_dubbo_weight(self, monitor, user, pwd, provider, weight):
        opeUrl = "http://%s:%s@%s/governance/addresses/%s:/providers/weight?weight=%s" % (user, pwd, monitor, provider, weight)
        print opeUrl
        try:
            r_ope = urllib.urlopen(opeUrl)
            text = r_ope.read().decode('utf-8')
            if text.find(dubbo.SUCCESS) == -1:
                if(text.find(dubbo.NO_PROVIDER) != -1):
                    print dubbo.NO_PROVIDER
                    return dubbo.RET_NO_PROVIDER
                else:
                    print text
                    return dubbo.RET_ERROR
            else :
                print dubbo.SUCCESS.encode('utf-8')
                return dubbo.RET_OK
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise

if __name__ == "__main__":
    if(len(sys.argv) != 6):
        error_str = "您需要传递5个参数，格式为：python dubbo_weight.py up|down dubboadmin:port adminUser adminPassword weight;\n 1、操作动作 \n 2、dubboadmin:port(dubboadmin应用暴露的服务) \n 3、adminUser(dubboadmin登录用户) \n 4、adminPassword(dubboadmin登录密码) \n 5、weight(权重)"
        print error_str
        raise Exception(error_str)
    else:
        operate, dubbo_admin, admin_user, admin_password, weight = sys.argv[1:6]

        my_name = socket.getfqdn(socket.gethostname())
        my_addr = socket.gethostbyname(my_name)
        print(my_addr)

        try:
            if (operate.lower() == "up"):
                cmd_ret = cmd().check_app_start(3, 180)
                if cmd_ret == cmd.JMX_ERROR:
                    raise Exception("cmd execute exception")
                elif cmd_ret == cmd.JMX_OK:
                    if not dubbo().set_dubbo_weight(dubbo_admin, admin_user, admin_password, my_addr, weight):
                        raise Exception("stop dubbo exception")
            else:
                dubbo_ret = dubbo().set_dubbo_weight(dubbo_admin, admin_user, admin_password, my_addr, weight)
                if dubbo_ret == dubbo.RET_ERROR:
                    raise Exception("stop dubbo exception")
                elif dubbo_ret == dubbo.RET_OK:
                    if not cmd().check_dubbo_stop(1, 3, 30):
                        raise Exception("cmd execute exception")
        except:
            print "Unexpected error:", sys.exc_info()[0]
            raise

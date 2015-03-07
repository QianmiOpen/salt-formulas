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

    def check_http_stop(self, max_invoke, interval, timeout):
        jmx_name = "com.ofpay.health:name=HealthStatus"
        jxm_attr = "Count"
        max_execute_times = (timeout + interval - 1) / interval
        (ret, invoke_num) = self.get_jmx(jmx_name, jxm_attr, int, 0)
        print("execute result %r, %r. max execute %d." % (ret, invoke_num, max_execute_times))
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
                print("wait %d times, invoke num is: %r" % (execute_time, invoke_num))

            return False
        elif ret == cmd.JMX_ERROR:
            time.sleep(timeout)
            return True
        elif ret == cmd.JMX_CONNECT_REFUSED:
            print "%s, please use 9000 for jmx port. " % cmd.CONNECT_REFUSED
            time.sleep(timeout)
            return True
        else:
            return False

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
            print "Unexpected error 1:", sys.exc_info()[0]
            return (cmd.JMX_ERROR, default)

class closingHttp(object):
    RET_OK = 0
    RET_ERROR = 1

    CLOSING_FAILED = 'closing http is failed!'
    CLOSING_SUCCESSED = 'closing http is successed!'

    def set_http_closing(self, ip, port = "8080", servlet = "/HealthServlet/check?closeGraceful=true"):
        opeUrl = "http://%s:%s%s" % (ip, port, servlet)
        print opeUrl
        try:
            r_ope = urllib.urlopen(opeUrl)
            r_code = r_ope.getcode()
            print r_code
            if r_code >= 400:
                print closingHttp.CLOSING_FAILED
                return closingHttp.RET_ERROR
            else:
                print closingHttp.CLOSING_SUCCESSED
                return closingHttp.RET_OK
        except:
            print "Unexpected error 2:", sys.exc_info()[0]
            raise

if __name__ == "__main__":
    if(len(sys.argv) != 2):
        error_str = "您需要传递1个参数，格式为：python http_invoke_jmx.py stop;"
        print error_str, sys.argv[1:]
        raise Exception(error_str)
    else:
        operate = sys.argv[1]

        my_name = socket.getfqdn(socket.gethostname())
        my_addr = socket.gethostbyname(my_name)
        # my_addr = "172.19.65.87"
        print(my_addr)

        try:
            if (operate.lower() == "stop"):
                ret_closing = closingHttp().set_http_closing(my_addr)
                if ret_closing == closingHttp.RET_OK:
                    if not cmd().check_http_stop(1, 3, 30):
                        raise Exception("cmd execute exception")
                else:
                    raise Exception("closing http exception")
            else:
                 raise Exception("operate is not valid")
        except:
            print "Unexpected error 3:", sys.exc_info()[0]
            raise

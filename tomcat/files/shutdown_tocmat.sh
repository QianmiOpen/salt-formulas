#/bin/sh

ps -ef |grep java |grep tomcat |grep -v grep
if [ "$?" -eq 0 ];then
  for num in 1 2 3 4 5 6 7 8 9 10
  do
  echo $num
  kill `cat /home/tomcat/tomcat.pid`
  ps -ef |grep java |grep tomcat |grep -v grep 
    if [ "$?" -eq 0 ];then
    sleep 1
    else
    exit 0
    fi
  done
kill -9 `cat /home/tomcat/tomcat.pid`
else
exit 0
fi

#!/bin/bash
############################################################################
#                                                                          #
#执行该脚本的前提是所有oracle用户脚本全部clone至oracle家目录下的allusers下 #
#allusers目录名称可更改，该脚本涉及该目录的地方也要更改。                  #
#用法：sh /home/oracle/autodb.sh username password version isinstall       #
############################################################################
v_username=$1
v_password=$2
v_version=$3
v_isinstall=$4

#若v_isinstall标记非true和false，则退出
if [ "$v_isinstall" != "true" -a "$v_isinstall" != "false" ];then
   exit 1
fi

#如果传入数据库用户不存在，则退出
tmpusername=`ls /home/oracle/allusers | grep $v_username`
if [ -z "$tmpusername" ];then
  exit 1
fi

cat /dev/null > /home/oracle/allsql.sql
for line in `ls -Rl /home/oracle/allusers/$v_username`
do
  if [[ "$line" == /home/oracle/allusers/$v_username/*: ]]; then
   dir=$line
  fi
  if [[ "$line" == *.sql ]]; then
   newdir=${dir%?}
   dir1=$newdir'/'$line 
   echo '@'$dir1 >> /home/oracle/allsql.sql 
  fi
done

#如果传入该用户版本号不存在，则退出
tmpversion=`cat /home/oracle/allsql.sql | grep $v_version/[0-9]*.[a-z]*.sql`
if [ -z "$tmpversion" ];then
  exit 1  
fi

if [ $v_isinstall = "false" ];then
RET=`sqlplus -S manager/ofcard <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT * FROM (SELECT version FROM version_info WHERE username='$v_username' order by operatdate desc,version desc) where rownum=1;
quit;
EOF`
current_version="$RET"

#如果传入版本号小于或等于库中该用户最新版本号，则退出
 if [ "$v_version" \< "$current_version" ] || [ "$v_version" = "$current_version" ];then
   exit 1
 fi
#如果当前是新库但是v_isinstall=false ,则退出
 if [ -z "$current_version" ];then
  exit 1
 fi
fi

i=0
j=0
linestart=()
lineend=()

linenum=`cat /home/oracle/allsql.sql | wc -l`
while [ $linenum -ge 1 ]
do
        lastline=`sed -n ${linenum}p /home/oracle/allsql.sql`
        if [[ $lastline =~ $v_version ]]; then
           lineend[$i]=${linenum}
           let i++
        fi
        if [ $v_isinstall = "false" ];then
         if [[ $lastline =~ $current_version ]]; then
           linestart[$j]=${linenum}
           let j++
         fi
        fi
        linenum=$((linenum - 1))
done

cat /dev/null > /home/oracle/$v_username.sql
if [ $v_isinstall = "true" ];then
  # echo "conn system/manager" >> /home/oracle/$v_username.sql
  # sed -n 1p /home/oracle/allsql.sql >> /home/oracle/$v_username.sql
  # echo "conn $v_username/$v_password" >> /home/oracle/$v_username.sql
   sed -n 1,${lineend[0]}p /home/oracle/allsql.sql >> /home/oracle/$v_username.sql
else
    let newupdate=${linestart[0]}+1
    #echo "conn $v_username/$v_password" >> /home/oracle/$v_username.sql
    sed -n $newupdate,${lineend[0]}p /home/oracle/allsql.sql >> /home/oracle/$v_username.sql 
fi

#扫描单个文件执行
#cat /home/oracle/$v_username.sql | while read line
for line in $(cat /home/oracle/$v_username.sql)
do
createuser=`echo $line | grep 00.user.sql`
if [ -z "$createuser" ];then

sqlplus -S system/manager<<EOF
spool /home/oracle/results.log
conn $v_username/$v_password
$line
spool off
quit;

EOF

else

sqlplus -S system/manager<<EOF
spool /home/oracle/results.log
$line
spool off
quit;

EOF
          
fi
#echo 'result1========'$result1
for resultline in $(cat /home/oracle/results.log)
do
if [[ $resultline =~ "ORA-" ]] || [[ $resultline =~ "SP2-" ]]; then
  exit 1
fi
done 

done

sqlplus -S manager/ofcard <<EOF

insert into version_info values('$v_username','$v_version',sysdate,'$v_isinstall');

commit;

exit;
EOF


{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

delete-work-dir:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/work

delete-dubbo-lock-file:
  cmd.run:
    - name: rm -rf {{ tomcat.home }}/.dubbocache/*.lock

#TODO 在该目录大于10M的时候，删除该目录
delete-dubbo-cache:
  cmd.run:
    - name: rm -rf {{ tomcat.home }}/.dubbocache
    - onlyif: "test `du -sk {{ tomcat.home }}/.dubbocache | awk '{print $1}'` -gt 10240"

delete-tomcat-log:
  cmd.run:
    - name: rm -rf {{ tomcat.home }}/{{ tomcat.name }}/logs/*


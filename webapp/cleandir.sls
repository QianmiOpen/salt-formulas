{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

delete-work-dir:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/work


#TODO 在该目录大于10M的时候，删除该目录
delete-dubbo-cache:
  file.absent:
    - name: {{ tomcat.home }}/.dubbocache

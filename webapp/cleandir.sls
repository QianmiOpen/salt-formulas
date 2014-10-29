{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

delete-work-dir:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/work

delete-dubbo-cache:
  file.absent:
    - name: {{ tomcat.home }}/.dubbocache

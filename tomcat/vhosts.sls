{% from "tomcat/settings.sls" import tomcat with context %}

/home/tomcat/tomcat/conf/server.xml:
  file.managed:
    - source: salt://tomcat/files/server.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
      tomcat: {{ tomcat|json }}

{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat_startup:
  cmd.run:
    - name: sh {{ tomcat.home }}/{{ tomcat.name }}/bin/catalina.sh start
    - user: tomcat

include:
  - webapp.cleandir
{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat_shutdown:
  cmd.run:
    - name: sh {{ tomcat.home }}/{{ tomcat.name }}/bin/catalina.sh stop {{ tomcat.stopDelaySeconds }} -force
    - user: tomcat
    - onlyif: 'test ! -e {{ tomcat.tomcatPid }}'

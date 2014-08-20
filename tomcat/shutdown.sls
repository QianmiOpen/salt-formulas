{%- from 'tomcat/settings.sls' import tomcat with context %}

# remove file if pid not exist
remove-tomcat-pid-file:
  cmd.run:
    - name: rm {{ tomcat.tomcatPid }}
    - user: tomcat
    - unless: 'ps -p `cat {{ tomcat.tomcatPid }}`'

tomcat_shutdown:
  cmd.run:
    - name: sh {{ tomcat.home }}/{{ tomcat.name }}/bin/catalina.sh stop {{ tomcat.stopDelaySeconds }} -force
    - user: tomcat
    - onlyif: 'test -e {{ tomcat.tomcatPid }}'

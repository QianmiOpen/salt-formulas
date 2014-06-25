{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat_shutdown:
  cmd.run:
    - name: sh {{ tomcat.home }}/{{ tomcat.name }}/bin/shutdown.sh
    - user: tomcat

tomcat_startup:
  cmd.run:
    - name: sh {{ tomcat.home }}/{{ tomcat.name }}/bin/startup.sh
    - user: tomcat

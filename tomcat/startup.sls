{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat_startup:
  cmd.run:
    - name: sh {{ tomcat.tomcat_home }}/{{ tomcat.tomcat_base }}/bin/startup.sh
    - user: tomcat

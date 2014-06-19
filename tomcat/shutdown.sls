{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat_shutdown:
  cmd.run:
    - name: sh {{ tomcat.tomcat_home }}/{{ tomcat.tomcat_base }}/bin/shutdown.sh
    - user: tomcat

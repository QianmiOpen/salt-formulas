{%- from 'tomcat/settings.sls' import tomcat with context %}

# remove file if pid not exist
remove-tomcat-pid-file:
  cmd.run:
    - name: rm -f {{ tomcat.tomcatPid }}
    - user: tomcat
    - unless: 'ps -p `cat {{ tomcat.tomcatPid }}`'

tomcat_shutdown:
  cmd.script:
    - name: salt://tomcat/files/shutdown_tocmat.sh -force
    - user: tomcat
    - onlyif: 'test -e {{ tomcat.tomcatPid }}'

# /home/tomcat/shutdown_tocmat.sh:
#   file.managed:
#     - source: salt://tomcat/files/shutdown_tocmat.sh
#     - user: tomcat
#     - group: tomcat
#     - mode: 644
#     - watch:
#       - cmd: set-dubbo-weight-0

# tomcat_shutdown:
#   cmd.run:
#     - name: sh {{ tomcat.home }}/{{ tomcat.name }}/bin/catalina.sh stop {{ tomcat.stopDelaySeconds }} -force
#     - user: tomcat
#     - onlyif: 'test -e {{ tomcat.tomcatPid }}'

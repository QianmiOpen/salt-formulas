{%- from 'tomcat/settings.sls' import tomcat with context %}

# remove file if pid not exist
remove-tomcat-pid-file:
  cmd.run:
    - name: rm -f {{ tomcat.tomcatPid }}
    - user: tomcat
    - unless: 'ps -p `cat {{ tomcat.tomcatPid }}`'

tomcat_shutdown:
  cmd.script:
    - name: salt://tomcat/files/shutdown_tocmat.sh
    - user: tomcat
    - onlyif: 'test -e {{ tomcat.tomcatPid }}'

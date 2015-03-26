{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

remove-tomcat-pid-file:
  cmd.run:
    - name: jstack -F `cat {{ tomcat.tomcatPid }}`
    - user: tomcat

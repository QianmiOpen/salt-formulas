{%- from 'tomcat/settings.sls' import tomcat with context %}
{%- from 'webapp/settings.sls' import webapp with context %}

include:
  - tomcat.user

copy-jmx-jar:
  file.managed:
    - name: {{ tomcat.home }}/cmdline-jmxclient-0.10.3.jar
    - source: salt://webapp/pkgs/cmdline-jmxclient-0.10.3.jar
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - mode: 644

set-dubbo-weight-0:
  cmd.script:
    - name: salt://webapp/files/dubbo_weight_jmx.py
    - args: "down {{webapp.dubboAdminIp}}:{{webapp.dubboAdminPort}} root {{webapp.dubboRootPasswd}} 0"
    - user: tomcat
    - require:
      - file: copy-jmx-jar

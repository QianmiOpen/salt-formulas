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

set-http-closing-true:
  cmd.script:
    - name: salt://webapp/files/http_invoke_jmx.py
    - args: "stop"
    - user: tomcat
    - onlyif: 'test -e {{ tomcat.tomcatPid }}'
    - require:
      - file: copy-jmx-jar
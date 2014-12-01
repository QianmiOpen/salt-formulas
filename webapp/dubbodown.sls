{%- from 'tomcat/settings.sls' import tomcat with context %}

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
    - args: "172.19.65.13:8080 root master123 20882 0"
    - user: tomcat
    - require:
      - file: copy-jmx-jar

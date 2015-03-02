{%- from 'tomcat/settings.sls' import tomcat with context %}

# 配置tomcat，使用logback输出日志
{{ tomcat.CATALINA_BASE }}/conf/context.xml:
  file.managed:
    - source: salt://tomcat/files/context.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - require:
      - file: symlink-tomcat

juli-jar:
  file.managed:
    - name: {{ tomcat.CATALINA_BASE }}/bin/tomcat-juli.jar
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/tomcat-juli.jar
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - file: symlink-tomcat

copy-logback-jars:
  file.recurse:
    - name: {{ tomcat.CATALINA_BASE }}/srvlib
    - source: salt://tomcat/pkgs/logback
    - saltenv: base
    - makedirs: true
    - user: tomcat
    - group: tomcat
    - require:
      - file: symlink-tomcat

{{ tomcat.CATALINA_BASE }}/conf/catalina.properties:
  file.managed:
    - source: salt://tomcat/files/catalina.properties
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}
    - require:
      - file: symlink-tomcat

{{ tomcat.CATALINA_BASE }}/conf/tomcat-logback.xml:
  file.managed:
    - source: salt://tomcat/files/tomcat-logback.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}
    - require:
      - file: symlink-tomcat

delete-logging.properties:
  file.absent:
    - name: {{ tomcat.CATALINA_BASE }}/conf/logging.properties
    - require:
      - file: symlink-tomcat

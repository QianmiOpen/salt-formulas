{%- from 'tomcat/settings.sls' import tomcat with context %}

include:
  - tomcat.env
{% if tomcat.forceInstall %}
  - tomcat.clean
{% endif %}
  - tomcat.user

get-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.package }}
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/{{ tomcat.package }}
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user

unpack-tomcat-tarball:
  cmd.run:
    - name: tar xf {{ tomcat.home }}/{{ tomcat.package }} -C {{ tomcat.home }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: get-tomcat-tarball

  file.directory:
    - name: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
    - makedirs: False
    - clean: False
    - require:
      - cmd: unpack-tomcat-tarball

symlink-tomcat:
  file.symlink:
    - name: {{ tomcat.home }}/{{ tomcat.name }}
    - target: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: unpack-tomcat-tarball


# temp 目录不能删除，部分jdk功能中，需要temp目录存放临时文件。--begin
{% for dir in ['webapps', 'LICENSE', 'NOTICE', 'RELEASE-NOTES', 'RUNNING.txt'] %}
delete-tomcat-{{ dir }}:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/{{ dir }}
    - require:
      - file: symlink-tomcat
{% endfor %}

delete-tomcat-users.xml:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/conf/tomcat-users.xml
    - require:
      - file: symlink-tomcat
# -- end

# 增加env.conf -- begin
copy-env.conf:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/conf/env.conf
    - source: salt://tomcat/files/env.conf
    - user: tomcat
    - group: tomcat
    - force: False
    - template: jinja
    - defaults:
      tomcatHome: {{ tomcat.home }}
    - require:
      - file: symlink-tomcat

/home/tomcat/tomcat/conf/server.xml:
  file.managed:
    - source: salt://tomcat/files/server.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
      tomcat: {{ tomcat|json }}
    - require:
      - file: symlink-tomcat

{% if tomcat.useLogback %}
{{ tomcat.CATALINA_BASE }}/conf/context.xml:
  file.managed:
    - source: salt://tomcat/files/context.xml
    - user: tomcat
    - group: tomcat
    - mode: 644

{{ tomcat.CATALINA_BASE }}/bin/catalina.sh:
  file.managed:
    - source: salt://tomcat/files/catalina.sh
    - user: tomcat
    - group: tomcat

juli-jar:
  file.managed:
    - name: {{ tomcat.CATALINA_BASE }}/bin/tomcat-juli.jar
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/tomcat-juli.jar
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: add-tomcat-user

copy-logback-jars:
  file.recurse:
    - name: {{ tomcat.CATALINA_BASE }}/srvlib
    - source: salt://tomcat/pkgs/logback
    - saltenv: base
    - makedirs: true
    - user: tomcat
    - group: tomcat
    - require:
      - user: add-tomcat-user

{{ tomcat.CATALINA_BASE }}/conf/catalina.properties:
  file.managed:
    - source: salt://tomcat/files/catalina.properties
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}

{{ tomcat.CATALINA_BASE }}/conf/tomcat-logback.xml:
  file.managed:
    - source: salt://tomcat/files/tomcat-logback.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}

{{ tomcat.CATALINA_BASE }}/conf/logback-common.xml:
  file.managed:
    - source: salt://tomcat/files/logback-common.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}
{% endif %}


{% if tomcat.gracefulOpen %}
copy-lib-jars:
  file.recurse:
    - name: {{ tomcat.CATALINA_BASE }}/lib
    - source: salt://tomcat/pkgs/lib
    - saltenv: base
    - makedirs: true
    - user: tomcat
    - group: tomcat
    - require:
      - file: symlink-tomcat
{% endif %}

delete-logging.properties:
  file.absent:
    - name: {{ tomcat.CATALINA_BASE }}/conf/logging.properties

{% do tomcat.update({'forceInstall': false}) %}

tomcat:
  grainsdict.present:
    - value: {{ tomcat|json }}
    - require:
      - cmd: unpack-tomcat-tarball
      - file: {{ tomcat.home }}/{{ tomcat.versionPath }}
      - file: symlink-tomcat
      - file: delete-tomcat-users.xml
      - file: {{ tomcat.home }}/{{ tomcat.name }}/conf/env.conf
      - file: /home/tomcat/tomcat/conf/server.xml
{% if tomcat.useLogback %}
      - file: {{ tomcat.CATALINA_BASE }}/conf/context.xml
      - file: {{ tomcat.CATALINA_BASE }}/bin/catalina.sh
      - file: juli-jar
      - file: copy-logback-jars
      - file: {{ tomcat.CATALINA_BASE }}/conf/catalina.properties
      - file: {{ tomcat.CATALINA_BASE }}/conf/tomcat-logback.xml
      - file: {{ tomcat.CATALINA_BASE }}/conf/logback-common.xml
{% endif %}
{% if tomcat.gracefulOpen %}    
      - file: copy-lib-jars
{% endif %}
      - file: delete-logging.properties


{%- from 'tomcat/settings.sls' import tomcat with context %}
{%- from 'webapp/settings.sls' import webapp with context %}

include:
  - tomcat.env
  - tomcat.user

delete-tomcat-linked-dir:
  cmd.run:
    - name: "rm -rf `readlink {{ tomcat.home }}/{{ tomcat.name }}`"
    - user: tomcat
    - onlyif: 'test -e {{ tomcat.home }}/{{ tomcat.name }}'

unpack-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.package }}
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/{{ tomcat.package }}
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user
      - cmd: delete-tomcat-linked-dir
  cmd.run:
    - name: tar xf {{ tomcat.home }}/{{ tomcat.package }} -C {{ tomcat.home }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: unpack-tomcat-tarball

symlink-tomcat:
  file.symlink:
    - name: {{ tomcat.home }}/{{ tomcat.name }}
    - target: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - user: tomcat
    - group: tomcat
    - require:
      - cmd: unpack-tomcat-tarball
  cmd.run:
    - name: rm {{ tomcat.home }}/{{ tomcat.package }}
    - user: tomcat
    - group: tomcat
    - require:
      - cmd: unpack-tomcat-tarball

# temp 目录不能删除，部分jdk功能中，需要temp目录存放临时文件。
{% for dir in ['webapps', 'LICENSE', 'NOTICE', 'RELEASE-NOTES', 'RUNNING.txt'] %}
delete-tomcat-{{ dir }}:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/{{ dir }}
{% endfor %}

delete-tomcat-users.xml:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/conf/tomcat-users.xml

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

# 配置tomcat，使用logback输出日志
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
      - user: tomcat-user

copy-logback-jars:
  file.recurse:
    - name: {{ tomcat.CATALINA_BASE }}/srvlib
    - source: salt://tomcat/pkgs/logback
    - saltenv: base
    - makedirs: true
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user

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

{{ tomcat.CATALINA_BASE }}/conf/logback-common.xml:
  file.managed:
    - source: salt://tomcat/files/logback-common.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
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
      - user: tomcat-user
{% endif %}

delete-logging.properties:
  file.absent:
    - name: {{ tomcat.CATALINA_BASE }}/conf/logging.properties

# grains中增加tomcat的version信息
tomcat_version:
  grains.present:
    - value: {{ tomcat.version }}

# move to os.security
# limits_conf:
#   file.append:
#     - name: /etc/security/limits.conf
#     - text:
#       - {{ tomcat.name }} soft nofile {{ tomcat.limitSoft }}
#       - {{ tomcat.name }} hard nofile {{ tomcat.limitHard }}

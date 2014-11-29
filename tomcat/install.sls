{%- from 'tomcat/settings.sls' import tomcat with context %}

include:
  - tomcat.env
  - tomcat.user

unpack-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.package }}
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/{{ tomcat.package }}
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user
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

/home/tomcat/dubbo_weight_jmx.py:
  file.managed:
    - source: salt://tomcat/files/dubbo_weight_jmx.py
    - user: tomcat
    - group: tomcat
    - mode: 644

/home/tomcat/cmdline-jmxclient-0.10.3.jar:
  file.managed:
    - source: salt://tomcat/pkgs/cmdline-jmxclient-0.10.3.jar
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - mode: 644

/home/tomcat/tomcat/conf/context.xml:
  file.managed:
    - source: salt://tomcat/files/context.xml
    - user: tomcat
    - group: tomcat
    - mode: 644

{{ tomcat.home }}/{{ tomcat.name }}/bin/catalina.sh:
  file.blockreplace:
    - marker_start: "# ----- Execute The Requested Command -----"
    - marker_end: "# Bugzilla 37848"
    - content: CATALINA_OPTS=`sed 's/"//g' $CATALINA_BASE/conf/env.conf |awk '/^[^#]/'| tr "\n" ' '`

# 配置tomcat，使用log4j输出日志
juli-jar:
  file.managed:
    - name: {{ tomcat.CATALINA_BASE }}/bin/tomcat-juli.jar
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/tomcat-juli.jar
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user

tomcat-juli-adapters-jar:
  file.managed:
    - name: {{ tomcat.CATALINA_BASE }}/lib/tomcat-juli-adapters.jar
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/tomcat-juli-adapters.jar
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user

# redis-appender-1.0.2-SNAPSHOT.jar
{% for jar in ['log4j-1.2.17.jar', 'redis-appender-1.0.1.jar', 'jedis-2.5.2.jar', 'jsonevent-layout-1.7.jar', 'json-smart-1.1.1.jar', 'commons-lang-2.6.jar'] %}
copy-{{ jar }}:
  file.managed:
    - name: {{ tomcat.CATALINA_BASE }}/lib/{{ jar }}
    - source: salt://tomcat/pkgs/{{ jar }}
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user
{% endfor %}

{{ tomcat.CATALINA_BASE }}/lib/log4j.properties:
  file.managed:
    - source: salt://tomcat/files/log4j.properties
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}

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

{%- from 'tomcat/settings.sls' import tomcat with context %}

include:
  - tomcat.env
  - tomcat.user
  - tomcat.clean


get-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.package }}
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/{{ tomcat.package }}
    - saltenv: base
    - user: tomcat
    - group: tomcat
    - require:
      - user: add-tomcat-user

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


delete-logging.properties:
  file.absent:
    - name: {{ tomcat.CATALINA_BASE }}/conf/logging.properties


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
      - file: delete-logging.properties


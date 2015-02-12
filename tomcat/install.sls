{%- from 'tomcat/settings.sls' import tomcat with context %}

include:
  - tomcat.env

delete-tomcat-linked-dir:
  cmd.run:
    - name: "rm -rf `readlink {{ tomcat.home }}/{{ tomcat.name }}`"
    - user: tomcat
    - onlyif: 'test -e {{ tomcat.home }}/{{ tomcat.name }}'

unpack-tomcat-tarball:
  archive.extracted:
    - name: {{ tomcat.home }}
    - source: salt://tomcat/pkgs/{{ tomcat.version }}/{{ tomcat.package }}
    - archive_format: tar
    - archive_user: tomcat
    - tar_options: x
    - if_missing: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - saltenv: base
    - require:
      - user: add-tomcat-user
{% if tomcat.forceInstall %}
      - file: delete-tomcat-linked-dir
{% endif %}
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
      - archive: unpack-tomcat-tarball

symlink-tomcat:
  file.symlink:
    - name: {{ tomcat.home }}/{{ tomcat.name }}
    - target: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: unpack-tomcat-tarball

include:
{% if tomcat.forceInstall %}
  - tomcat.clean
{% endif %}
  - tomcat.user
{% if tomcat.useLogback %}
  - tomcat.uselogback
{% endif %}

tomcat-profile-config:
  file.managed:
    - name: /etc/profile.d/tomcat.sh
    - source: salt://tomcat/files/tomcat.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      tomcatHome: {{ tomcat.home }}/{{ tomcat.name }}
      tomcatPid: {{ tomcat.tomcatPid }}

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
{{ tomcat.CATALINA_BASE }}/bin/catalina.sh:
  file.managed:
    - source: salt://tomcat/files/catalina.sh
    - user: tomcat
    - group: tomcat
    - require:
      - file: symlink-tomcat

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

{{ tomcat.CATALINA_BASE }}/conf/logback-common.xml:
  file.managed:
    - source: salt://tomcat/files/logback-common.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - defaults:
        tomcat: {{ tomcat|json }}


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

{% do tomcat.update({'forceInstall': false}) %}

tomcat:
  grainsdict.present:
    - value: {{ tomcat|json }}
    - require:
      - cmd: delete-tomcat-linked-dir
      - archive: unpack-tomcat-tarball
      - file: symlink-tomcat
      - file: delete-tomcat-users.xml
      - file: {{ tomcat.CATALINA_BASE }}/bin/catalina.sh
      - file: copy-env.conf
      - file: /home/tomcat/tomcat/conf/server.xml
      - file: {{ tomcat.CATALINA_BASE }}/conf/logback-common.xml


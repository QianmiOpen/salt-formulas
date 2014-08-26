{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

delete-tomcat-appbase:
  file.absent:
    - name: {{ tomcat.appBase }}

download-war-file:
  file.managed:
    - name: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - source: http://{{ webapp.fileUrl }}
    - source_hash: http://{{ webapp.fileSha1 }}
    - user: tomcat
    - group: tomcat
    - makedirs: true
    - require:
      - file: delete-tomcat-appbase

{% if webapp.unzip %}
unzip-war-file:
  file.directory:
    - name: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}
    - makedirs: true
    - user: tomcat
    - group: tomcat
  cmd.run:
    - name: jar xf {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - cwd: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}
    - user: tomcat
    - group: tomcat

symlink-war-file:
  file.symlink:
    - name: {{ tomcat.appBase }}/{{ tomcat.appName }}.war
    - target: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}
    - user: tomcat
    - group: tomcat
{% else %}
symlink-war-file:
  file.symlink:
    - name: {{ tomcat.appBase }}/{{ tomcat.appName }}.war
    - target: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - user: tomcat
    - group: tomcat
{% endif %}

include:
  - tomcat.vhosts

{#  todo: 是否需要删除webapps目录和work目录？另，server.xml需要和现在已经上线的文件进行比对。  #}
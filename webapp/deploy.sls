{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

download-war-file:
  file.managed:
    - name: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - source: http://{{ webapp.fileUrl }}
    - source_hash: http://{{ webapp.fileSha1 }}
    - user: tomcat
    - group: tomcat

symlink-war-file:
  file.symlink:
    - name: {{ tomcat.appBase }}/{{ tomcat.appName }}.war
    - target: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - user: tomcat
    - group: tomcat

delete-work-dir:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/work

include:
  - tomcat.vhosts

{#  todo: 是否需要删除webapps目录和work目录？另，server.xml需要和现在已经上线的文件进行比对。  #}
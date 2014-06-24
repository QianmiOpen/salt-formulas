{% from 'tomcat/settings.sls' import tomcat with context %}
{% from 'webapp/settings.sls' import webapp with context %}

download_war_file:
  file.managed:
    - name: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - source: http://{{ webapp.fileUrl }}
    - source_hash: http://{{ webapp.fileSha1 }}
    - user: tomcat
    - group: tomcat
  alternatives.install:
    - name: app-link
    - user: tomcat
    - group: tomcat
    - link: {{ tomcat.appBase }}/{{ webapp.artifactId }}.war
    - path: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war
    - priority: 30

set_app_link:
  alternatives.set:
      - name: app-link
      - path: {{ tomcat.appBase }}/{{ webapp.artifactId }}-{{ webapp.version }}.war

include:
  - tomcat.vhosts
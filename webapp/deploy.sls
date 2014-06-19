{%- from 'tomcat/settings.sls' import tomcat with context %}
{%- from 'webapp/settings.sls' import webapp with context %}

download_war_file:
  file.managed:
    - name: {{ tomcat.appBase }}/{{ webapp.appName }}-{{ webapp.appVersion }}.war
    - source: salt://webapp/files/{{ webapp.appName }}-{{ webapp.appVersion }}.war
    - user: tomcat
    - group: tomcat
  alternatives.install:
    - name: app-link
    - user: tomcat
    - group: tomcat
    - link: {{ tomcat.appBase }}/{{ webapp.appName }}.war
    - path: {{ tomcat.appBase }}/{{ webapp.appName }}-{{ webapp.appVersion }}.war
    - priority: 30

set_app_link:
  alternatives.set:
      - name: app-link
      - path: {{ tomcat.appBase }}/{{ webapp.appName }}-{{ webapp.appVersion }}.war

include:
  - tomcat.vhosts
{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat-config:
  file.managed:
    - name: /etc/profile.d/tomcat.sh
    - source: salt://tomcat/files/tomcat.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      tomcatHome: {{ tomcat.home }}/{{ tomcat.name }}

{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat-config:
  file.managed:
    - name: /etc/profile.d/tomcat.sh
    - source: salt://tomcat/tomcat.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      tomcat_home: {{ tomcat.tomcat_home }}/{{ tomcat.tomcat_base }}
      java_Xmx: {{ tomcat.java_Xmx }}
      java_MaxPermSize: {{ tomcat.java_MaxPermSize }}

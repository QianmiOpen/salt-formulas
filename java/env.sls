{%- from 'java/settings.sls' import java with context %}

jdk-config:
  file.managed:
    - name: /etc/profile.d/java.sh
    - source: salt://java/files/java.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      javaHome: {{ java.home }}

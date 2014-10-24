{%- from 'sbt/settings.sls' import sbt with context %}

sbt-config:
  file.managed:
    - name: /etc/profile.d/sbt.sh
    - source: salt://sbt/files/sbt.sh
    - template: jinja
    - mode: 744
    - user: root
    - group: root
    - context:
      sbtHome: {{sbt.sbtHome}} 


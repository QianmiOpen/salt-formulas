{%- from 'tomcat/settings.sls' import tomcat with context %}

add-tomcat-user:
  user.present:
    - name: tomcat
    - uid: 6666
    - gid: 6666
    - home: {{ tomcat.home }}
    - shell: /bin/bash
    - require:
      - group: tomcat
  group.present:
    - name: tomcat
    - gid: 6666

{{ tomcat.home }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 755
    - makedirs: True
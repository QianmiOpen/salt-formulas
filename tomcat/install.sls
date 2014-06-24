{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat-user:
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

unpack-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.package }}
    - source: salt://tomcat/pkgs/{{ tomcat.package }}
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user
  cmd.run:
    - name: tar xf {{ tomcat.home }}/{{ tomcat.package }} -C {{ tomcat.home }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: unpack-tomcat-tarball
  alternatives.install:
    - name: tomcat-home-link
    - user: tomcat
    - group: tomcat
    - link: {{ tomcat.home }}/{{ tomcat.name }}
    - path: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - priority: 30

{% for dir in ['docs', 'examples', 'host-manager', 'manager', 'ROOT'] %}
delete-tomcat-webapps-{{ dir }}:
  file.absent:
    - name: {{ tomcat.appBase }}/{{ dir }}
{% endfor %}

include:
  - tomcat.env

limits_conf:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - {{ tomcat.name }} soft nofile {{ tomcat.limitSoft }}
      - {{ tomcat.name }} hard nofile {{ tomcat.limitHard }}

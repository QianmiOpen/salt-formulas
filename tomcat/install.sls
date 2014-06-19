{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat-user:
  user.present:
    - name: tomcat
    - uid: 6666
    - gid: 6666
    - home: {{ tomcat.tomcat_home }}
    - shell: /bin/bash
    - require:
      - group: tomcat
  group.present:
    - name: tomcat
    - gid: 6666

unpack-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.tomcat_home }}/{{ tomcat.tomcat_package }}
    - source: salt://tomcat/pkgs/{{ tomcat.tomcat_package }}
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user
  cmd.run:
    - name: tar xf {{ tomcat.tomcat_home }}/{{ tomcat.tomcat_package }} -C {{ tomcat.tomcat_home }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: unpack-tomcat-tarball
  alternatives.install:
    - name: tomcat-home-link
    - user: tomcat
    - group: tomcat
    - link: {{ tomcat.tomcat_home }}/{{ tomcat.tomcat_base }}
    - path: {{ tomcat.tomcat_home }}/{{ tomcat.version_path }}
    - priority: 30

include:
  - tomcat.env

{% if grains.os != 'FreeBSD' %}
limits_conf:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - {{ salt['pillar.get']('tomcat:name', 'tomcat') }} soft nofile {{ salt['pillar.get']('limit:soft', '64000') }}
      - {{ salt['pillar.get']('tomcat.name', 'tomcat') }} hard nofile {{ salt['pillar.get']('limit:hard', '64000') }}
{% endif %}

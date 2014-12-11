{%- from 'java/settings.sls' import java with context %}

{{ java.installPath }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

unpack-jdk-tarball:
  archive.extracted:
    - name: {{ java.installPath }}
    - source: salt://java/pkgs/{{ java.package }}
    - archive_format: tar
    - archive_user: root
    - tar_options: x
    - if_missing: {{ java.realHome }}
    - saltenv: base
    - require:
      - file: {{ java.installPath }}

{% if  java.version  == 'jdk7' %}
copy-security-jar:
  file.recurse:
    - name: {{ java.realHome }}/jre/lib/security
    - source: salt://java/pkgs/jdk7_lib
    - saltenv: base
    - user: root
    - group: root
    - require:
      - archive: unpack-jdk-tarball
{% endif %}

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

symlink-java:
  file.symlink:
    - name: {{ java.home }}
    - target: {{ java.realHome }}
    - user: root
    - group: root

{% if java.forceInstall %}
include:
  - java.clean
{% endif %}

{% do java.update({'forceInstall': false}) %}
{% do salt['grains.setval']('java', java) %}
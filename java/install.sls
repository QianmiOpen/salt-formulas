{%- from 'java/settings.sls' import java with context %}

{{ java.installPath }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

tar:
  pkg.installed

unpack-jdk-tarball:
  file.managed:
    - name: {{ java.installPath }}/{{ java.package }}
    - source: salt://java/pkgs/{{ java.package }}
    - saltenv: base
  cmd.run:
    - name: tar xf {{ java.installPath }}/{{ java.package }} -C {{ java.installPath }}
    - require:
      - pkg: tar
      - file: {{ java.installPath }}
      - file: unpack-jdk-tarball

{% if  java.version  == 'jdk7' %}
{% for jar in ['local_policy.jar', 'US_export_policy.jar'] %}
copy-{{ jar }}:
  file.managed:
    - name: {{ java.realHome }}/jre/lib/security/{{ jar }}
    - source: salt://java/pkgs/jdk7_lib/{{ jar }}
    - saltenv: base
    - user: root
    - group: root
{% endfor %}
{% endif %}

symlink-java:
  file.symlink:
    - name: /usr/lib/java
    - target: {{ java.realHome }}
    - user: root
    - group: root

java_version:
  grains.present:
    - value: {{ java.version }}

include:
  - java.env
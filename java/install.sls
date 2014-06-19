{%- from 'java/settings.sls' import java with context %}

{%- if java.package is defined %}

{{ java.prefix }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

unpack-jdk-tarball:
  file.managed:
    - name: {{ java.prefix }}/{{ java.package }}
    - source: salt://java/pkgs/{{ java.package }}
  cmd.run:
    - name: tar xf {{ java.prefix }}/{{ java.package }} -C {{ java.prefix }}
    - require:
      - file: {{ java.prefix }}
      - file: unpack-jdk-tarball
  alternatives.install:
    - name: java-home-link
    - link: {{ java.java_home }}
    - path: {{ java.java_real_home }}
    - priority: 30

{%- if java.init_env %}
include:
  - java.env

{%- endif %}
{%- endif %}
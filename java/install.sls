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
    - env: base
  cmd.run:
    - name: tar xf {{ java.installPath }}/{{ java.package }} -C {{ java.installPath }}
    - require:
      - pkg: tar
      - file: {{ java.installPath }}
      - file: unpack-jdk-tarball
  alternatives.install:
    - name: java-home-link
    - link: {{ java.home }}
    - path: {{ java.realHome }}
    - priority: 30

include:
  - java.env

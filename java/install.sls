{%- from 'java/settings.sls' import java with context %}

tar:
  pkg:
    - installed

{{ java.installPath }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

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

java:
  grainsdict.present:
    - value: {{ java|json }}
    - require:
      - cmd: unpack-jdk-tarball
      - file: jdk-config
      - file: symlink-java

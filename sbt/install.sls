{%- from 'sbt/settings.sls' import sbt with context %}

include:
  - sbt.env

{{sbt.installPath}}:
   file.directory:
     - user: root
     - group: root
     - mode: 755 

unpack-sbt-tarball:
   file.managed:
     - name: {{sbt.installPath}}/{{sbt.package}}
     - source: salt://sbt/pkgs/{{sbt.package}}
     - saltenv: base
     - user: root
     - group: root
   cmd.run:
     - name: tar xf {{sbt.installPath}}/{{sbt.package}} -C {{sbt.installPath}}
     - user: root
     - group: root
     - require:
        - file: unpack-sbt-tarball


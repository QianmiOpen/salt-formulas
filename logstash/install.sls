{%- from 'logstash/settings.sls' import logstash with context %}

tar:
  pkg.installed

unpack-logstash-tarball:
  file.managed:
    - name: {{ logstash.base }}/{{ logstash.package }}
    - source: salt://logstash/pkgs/{{ logstash.package }}
    - saltenv: base
  cmd.run:
    - name: tar xf {{ logstash.base }}/{{ logstash.package }} -C {{ logstash.base }}
    - require:
      - pkg: tar
      - file: unpack-logstash-tarball

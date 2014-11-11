{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

tar:
  pkg.installed

unpack-elasticsearch-tarball:
  file.managed:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.package }}
    - source: salt://elasticsearch/pkgs/{{ elasticsearch.package }}
    - saltenv: base
  cmd.run:
    - name: tar xf {{ elasticsearch.base }}/{{ elasticsearch.package }} -C {{ elasticsearch.base }}
    - require:
      - pkg: tar
      - file: unpack-elasticsearch-tarball

elasticsearch_config:
  file:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.prefix }}-{{ elasticsearch.version }}/config/elasticsearch.yml
    - managed
    - template: jinja
    - source: salt://elasticsearch/files/elasticsearch.yml

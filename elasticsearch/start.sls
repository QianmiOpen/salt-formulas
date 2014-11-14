{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch-start:
  cmd.run:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.prefix }}'-'{{ elasticsearch.version }}/bin/elasticsearch -d
    - user: root
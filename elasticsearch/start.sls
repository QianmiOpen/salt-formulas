{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch-start:
  cmd.run:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.prefix }}/bin/service/elasticsearch start
    - user: elasticsearch

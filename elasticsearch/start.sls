{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch-start:
  cmd.run:
    - name: {{ elasticsearch.home }}/bin/service/elasticsearch start
    - user: elasticsearch

{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch_stop:
  cmd.run:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.prefix }}/bin/service/elasticsearch stop
    - user: elasticsearch

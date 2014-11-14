{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch_stop:
  cmd.run:
    - name: {{ elasticsearch.home }}/bin/service/elasticsearch stop
    - user: elasticsearch

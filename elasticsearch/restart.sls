{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

include:
  - elasticsearch.stop
  - elasticsearch.start

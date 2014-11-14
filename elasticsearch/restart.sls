{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

include:
  - elasticsearch.start
  - elasticsearch.stop
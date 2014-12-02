{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch_user:
  user.present:
    - name: elasticsearch
    - uid: 8888
    - gid: 8888
    - home: {{ elasticsearch.base }}
    - shell: /bin/bash
    - require:
      - group: elasticsearch
  group.present:
    - name: elasticsearch
    - gid: 8888

{{ elasticsearch.base }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: 755
    - makedirs: True

{{ elasticsearch.home }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: 755
    - makedirs: True
{%- from 'logstash/settings.sls' import logstash with context %}

logstash-user:
  user.present:
    - name: logstash
    - uid: 7777
    - gid: 7777
    - home: {{ logstash.home }}
    - shell: /bin/bash
    - require:
      - group: logstash
  group.present:
    - name: logstash
    - gid: 7777

{{ logstash.home }}:
  file.directory:
    - user: logstash
    - group: logstash
    - mode: 755
    - makedirs: True
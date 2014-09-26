{%- from 'zookeeper/settings.sls' import zookeeper with context %}

zookeeper-user:
  user.present:
    - name: zookeeper
    - uid: 6665
    - gid: 6665
    - home: {{ zookeeper.home }}
    - shell: /bin/bash
    - require:
      - group: zookeeper
  group.present:
    - name: zookeeper
    - gid: 6665

{{ zookeeper.home }}:
  file.directory:
    - user: zookeeper
    - group: zookeeper
    - mode: 755
    - makedirs: True
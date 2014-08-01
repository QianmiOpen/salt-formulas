{%- from 'zookeeper/settings.sls' import zookeeper with context %}

zookeeper-start:
  cmd.run:
    - name: /{{ zookeeper.zookeeperVersion }}/bin/zkServer.sh start
    - user: root
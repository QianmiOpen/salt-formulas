{%- from 'zookeeper/settings.sls' import zookeeper with context %}

zookeeper-start:
  cmd.run:
    - name: /{{ zookeeper.home }}/{{ zookeeper.zookeeperVersion }}/bin/zkServer.sh start
    - user: zookeeper
    - group: zookeeper 
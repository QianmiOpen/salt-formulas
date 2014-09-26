{%- from 'zookeeper/settings.sls' import zookeeper with context %}

zookeeper-restart:
  cmd.run:
    - name: /{{ zookeeper.home }}/{{ zookeeper.zookeeperVersion }}/bin/zkServer.sh restart
    - user: zookeeper
    - group: zookeeper 

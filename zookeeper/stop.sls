{%- from 'zookeeper/settings.sls' import zookeeper with context %}

zookeeper-stop:
  cmd.run:
    - name: sh /{{ zookeeper.zookeeperVersion }}/bin/zkServer.sh stop
    - user: root
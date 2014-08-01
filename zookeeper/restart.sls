{%- from 'zookeeper/settings.sls' import zookeeper with context %}

zookeeper-restart:
  cmd.run:
    - name: /{{ zookeeper.zookeeperVersion }}/bin/zkServer.sh restart
    - user: root

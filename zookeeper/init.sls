{%- from 'zookeeper/settings.sls' import zookeeper with context %}

get-zookeeper-package:
  file.managed:
    - name: /{{ zookeeper.zookeeperVersion }}{{ zookeeper.zipType }}
    - source: salt://zookeeper/pkgs/{{ zookeeper.zookeeperVersion }}{{ zookeeper.zipType }}
  cmd.run:
    - name: tar -zxf /{{ zookeeper.zookeeperVersion }}{{ zookeeper.zipType }} -C / 
    - watch:
      - file: get-zookeeper-package

{% for file in ['zoo.cfg', 'log4j.properties'] %}
copy-configue-file-{{ file }}:
  file.managed:
    - name: /{{ zookeeper.zookeeperVersion }}/conf/{{ file }}
    - source: salt://zookeeper/files/{{ file }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: get-zookeeper-package
{% endfor %}

{% for file in ['zkServer.sh', 'zkEnv.sh'] %}
copy-bin-file-{{ file }}:
  file.managed:
    - name: /{{ zookeeper.zookeeperVersion }}/bin/{{ file }}
    - source: salt://zookeeper/files/{{ file }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: get-zookeeper-package
{% endfor %}

include:
  - java.install

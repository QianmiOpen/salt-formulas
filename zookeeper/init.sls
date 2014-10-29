{%- from 'zookeeper/settings.sls' import zookeeper with context %}

include:
  - zookeeper.user
  - java.install

get-zookeeper-package:
  file.managed:
    - name: /{{ zookeeper.zookeeperVersion }}{{ zookeeper.zipType }}
    - source: salt://zookeeper/pkgs/{{ zookeeper.zookeeperVersion }}{{ zookeeper.zipType }}
    - saltenv: base
    - user: zookeeper
    - group: zookeeper
    - require:
      - user: zookeeper-user
  cmd.run:
    - name: tar -zxf /{{ zookeeper.zookeeperVersion }}{{ zookeeper.zipType }} -C /{{ zookeeper.home }}
    - user: zookeeper
    - group: zookeeper 
    - watch:
      - file: get-zookeeper-package

zookeeper-data-dir:
  file.directory:
    - name: /{{ zookeeper.zkdataPath }}
    - user: zookeeper
    - group: zookeeper
    - mode: 755
    - makedirs: True

{% for file in ['zoo.cfg', 'log4j.properties'] %}
copy-configue-file-{{ file }}:
  file.managed:
    - name: /{{ zookeeper.home }}/{{ zookeeper.zookeeperVersion }}/conf/{{ file }}
    - source: salt://zookeeper/files/{{ file }}
    - user: zookeeper
    - group: zookeeper
    - mode: 644
    - require:
      - cmd: get-zookeeper-package
{% endfor %}

{% for file in ['zkServer.sh', 'zkEnv.sh'] %}
copy-bin-file-{{ file }}:
  file.managed:
    - name: /{{ zookeeper.home }}/{{ zookeeper.zookeeperVersion }}/bin/{{ file }}
    - source: salt://zookeeper/files/{{ file }}
    - user: zookeeper
    - group: zookeeper
    - mode: 755
    - require:
      - cmd: get-zookeeper-package
{% endfor %}

zookeeper_version:
  grains.present:
    - value: {{ zookeeper.zookeeperVersion }}

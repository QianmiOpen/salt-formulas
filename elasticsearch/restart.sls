{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch-stop:
  cmd.run:
    - name: kill -9 `ps -ef |grep elasticsearch |grep -v grep |awk '{print $2}'`
    - user: root

elasticsearch-start:
  cmd.run:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.prefix }}'-'{{ elasticsearch.version }}/bin/elasticsearch -d
    - user: root

{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

elasticsearch-stop:
  cmd.run:
    - name: kill -9 `ps -ef |grep elasticsearch |grep -v grep |awk '{print $2}'`
    - user: root
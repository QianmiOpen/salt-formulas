{%- from 'activemq/settings.sls' import activemq with context %}

activemq-stop:
  cmd.run:
    - name: kill -9 `ps -ef |grep active  |grep -v grep |awk '{print $2}'`
    - user: root
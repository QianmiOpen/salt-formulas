{%- from 'logstash/settings.sls' import logstash with context %}

logstash-start:
  cmd.run:
    - name: /etc/init.d/logstash start
    - user: root
    - onlyif: "test `ps -ef |grep logstash |grep -v grep |wc -l` -lt 1"

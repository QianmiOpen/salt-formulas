{%- from 'logstash/settings.sls' import logstash with context %}

logstash-stop:
  cmd.run:
    - name: /etc/init.d/logstash stop
    - user: root
    - onlyif: "test `ps -ef |grep logstash |grep java |grep -v grep |wc -l` -gt 0"

logstash-start:
  cmd.run:
    - name: /etc/init.d/logstash start
    - user: root
    - onlyif: "test `ps -ef |grep logstash |grep java |grep -v grep |wc -l` -lt 1"

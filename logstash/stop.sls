{%- from 'logstash/settings.sls' import logstash with context %}

logstash-stop:
  cmd.run:
    - name: /etc/init.d/logstash stop
    - user: root
    - onlyif: "test `ps -ef |grep logstash |grep -v grep |wc -l` -gt 0"

{%- from 'logstash/settings.sls' import logstash with context %}

logstash-start:
  cmd.run:
    - name: /etc/init.d/logstash start
    - user: root

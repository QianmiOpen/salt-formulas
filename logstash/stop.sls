{%- from 'logstash/settings.sls' import logstash with context %}

logstash-stop:
  cmd.run:
    - name: /etc/init.d/logstash stop
    - user: root

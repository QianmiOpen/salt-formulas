{%- from 'logstash/settings.sls' import logstash with context %}

logstash_delete_conf:
  cmd.run:
    - name: rm -rf  {{ logstash.home }}/{{ logstash.prefix }}/conf/*.conf
    - user: root
    - onlyif: 'test -d {{ logstash.home }}/{{ logstash.prefix }}/conf'

{%- from 'logstash/settings.sls' import logstash with context %}

{% for configfile in ['01-inputs.conf', '02-filters.conf', '03-outputs.conf'] %}
logstash-config-{{ configfile }}:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/conf/{{ configfile }}
    - user: logstash
    - group: logstash
    - mode: 755
    - source: salt://logstash/files/{{ configfile }}
    - template: jinja
{% endfor %}
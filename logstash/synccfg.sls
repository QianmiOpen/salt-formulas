{%- from 'logstash/settings.sls' import logstash with context %}

{% for configfile in ['02-filters.conf', '03-outputs.conf'] %}
logstash-config-{{ configfile }}:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/conf/{{ configfile }}
    - user: logstash
    - group: logstash
    - mode: 755
    - source: salt://logstash/files/{{ configfile }}
    - template: jinja
    - require:
      - cmd: unpack-logstash-tarball
{% endfor %}

{% set ip_str = logstash.redisIPList  %}
{% set ip_arr = ip_str.split(',') %}
{% for ip in ip_str.split(',') %}
{% if  loop.length  > 0 %}
logstash-config-01-inputs-conf-{{ ip }}:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/conf/01-inputs-{{ ip }}.conf
    - user: logstash
    - group: logstash
    - mode: 755
    - source: salt://logstash/files/01-inputs.conf
    - template: jinja
    - context:
      redisIP: {{ ip }}
    - require:
      - cmd: unpack-logstash-tarball
{% endif %}
{% endfor %}
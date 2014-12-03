{%- from 'logstash/settings.sls' import logstash with context %}

include:
  - logstash.user

tar:
  pkg.installed

unpack-logstash-tarball:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.package }}
    - source: salt://logstash/pkgs/{{ logstash.package }}
    - saltenv: base
    - user: logstash
    - group: logstash
  cmd.run:
    - name: tar xf {{ logstash.home }}/{{ logstash.package }} -C {{ logstash.home }}
    - user: logstash
    - group: logstash
    - require:
      - pkg: tar
      - file: unpack-logstash-tarball

symlink-logstash:
  file.symlink:
    - name: {{ logstash.home }}/{{ logstash.prefix }}
    - target: {{ logstash.home }}/{{ logstash.prefix }}-{{ logstash.version }}
    - user: logstash
    - group: logstash
    - require:
      - cmd: unpack-logstash-tarball
  cmd.run:
    - name: rm {{ logstash.home }}/{{ logstash.package }}
    - user: root
    - group: root
    - require:
      - cmd: unpack-logstash-tarball


{% for dir in ['tmp', 'logs', 'conf'] %}
logstash-app-{{ dir }}:
  file.directory:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/{{ dir }}
    - user: logstash
    - group: logstash
    - require:
      - cmd: unpack-logstash-tarball
{% endfor %}      

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

logstash-lib-sh:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/bin/logstash.lib.sh
    - user: logstash
    - group: logstash
    - mode: 755
    - source: salt://logstash/files/logstash.lib.sh
    - template: jinja
    - require:
      - cmd: unpack-logstash-tarball

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

logstash-plugins-dir:
  file.directory:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/lib/logstash/outputs/websocket
    - mode: 755
    - user: logstash
    - group: logstash
    - makedirs: True
    - require:
      - cmd: unpack-logstash-tarball

{% for pluginsfile in ['pubsub.rb', 'app.rb'] %}
logstash-plugins-{{ pluginsfile }}:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/lib/logstash/outputs/websocket/{{ pluginsfile }}
    - user: logstash
    - group: logstash
    - mode: 755
    - source: salt://logstash/plugins/outputs/websocket/{{ pluginsfile }}
    - template: jinja
{% endfor %}

logstash-plugins-websocket:
  file.managed:
    - name: {{ logstash.home }}/{{ logstash.prefix }}/lib/logstash/outputs/websocket.rb
    - user: logstash
    - group: logstash
    - mode: 755
    - source: salt://logstash/plugins/outputs/websocket.rb
    - template: jinja

logstash-operation-script:
  file.managed:
    - name: /etc/init.d/logstash
    - user: root
    - group: root
    - mode: 755
    - source: salt://logstash/files/logstash
    - template: jinja

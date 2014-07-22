{%- from 'tengine/settings.sls' import tengine with context %}

configue-server-file:
  file.managed:
    - name: {{ tengine.installPath }}/conf/servers/{{ tengine.domain }}.conf
    - source: salt://tengine/files/server.template.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - template: jinja
    - defaults:
        tengine: {{ tengine|json }}


configue-server-iplist:
  file.append:
    - name: {{ tengine.installPath }}/conf/servers/{{ tengine.domain }}.iplist
    - makedirs: true
    - text:
      - server {{ tengine.ip }}:{{ tengine.port }};



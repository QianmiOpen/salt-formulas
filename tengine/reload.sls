{%- from 'tengine/settings.sls' import tengine with context %}

include:
  - tengine.testconf

tengine-reload:
  cmd.run:
    - name: {{ tengine.installPath }}/sbin/nginx -s reload
    - user: root
    - watch:
      - cmd: tengine-test-conf
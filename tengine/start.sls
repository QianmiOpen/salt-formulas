{%- from 'tengine/settings.sls' import tengine with context %}

include:
  - tengine.testconf

tengine-start:
  cmd.run:
    - name: {{ tengine.installPath }}/sbin/nginx
    - user: root
    - watch:
      - cmd: tengine-test-conf
{%- from 'tengine/settings.sls' import tengine with context %}

tengine-test-conf:
  cmd.run:
    - name: {{ tengine.installPath }}/sbin/nginx -t
    - user: root



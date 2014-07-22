{%- from 'tengine/settings.sls' import tengine with context %}

tengine-stop:
  cmd.run:
    - name: {{ tengine.installPath }}/sbin/nginx -s stop
    - user: root
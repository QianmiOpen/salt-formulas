{%- from 'keepalived/settings.sls' import keepalived with context %}

keepalived-start:
  cmd.run:
    - name: service keepalived start
    - user: root
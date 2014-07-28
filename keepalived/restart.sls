{%- from 'keepalived/settings.sls' import keepalived with context %}

keepalived-stop:
  cmd.run:
    - name: service keepalived stop
    - user: root

keepalived-start:
  cmd.run:
    - name: service keepalived start
    - user: root
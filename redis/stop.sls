{%- from 'redis/settings.sls' import redis with context %}

redis-stop:
  cmd.run:
    - name: service redisd stop
    - user: root

include:
  - keepalived.run
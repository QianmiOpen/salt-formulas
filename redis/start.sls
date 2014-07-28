{%- from 'redis/settings.sls' import redis with context %}

redis-start:
  cmd.run:
    - name: service redisd start
    - user: root

include:
  - keepalived.run
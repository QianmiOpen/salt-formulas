{%- from 'redis/settings.sls' import redis with context %}

redis-stop:
  cmd.run:
    - name: service redisd stop
    - user: root

redis-start:
  cmd.run:
    - name: service redisd start
    - user: root
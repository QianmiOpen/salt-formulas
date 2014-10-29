{%- from 'redis/map.jinja' import redis with context %}

get-redis-package:
  file.managed:
    - name: /{{ redis.redisVersion }}{{ redis.zipType }}
    - source: salt://redis/pkgs/{{ redis.redisVersion }}{{ redis.zipType }}
    - saltenv: base
  cmd.run:
    - name: tar -zxf /{{ redis.redisVersion }}{{ redis.zipType }} -C / 
    - watch:
      - file: get-redis-package

compile-redis:
  cmd.wait:
    - cwd: /{{ redis.redisVersion }}
    - names:
      - make && make install
    - watch:
      - cmd: get-redis-package

redis-pid-dir:
  file.directory:
    - name: /var/run/redis
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

redis-lib-dir:
  file.directory:
    - name: /var/lib/redis
    - mode: 755
    - user: root
    - group: root
    - makedirs: True      

redis-log-dir:
  file.directory:
    - name: /var/log/redis
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

redis_config:
  file:
    - name: /etc/redis.conf
    - managed
    - template: jinja
    - source: salt://redis/files/{{ redis.redisVersion }}.conf.jinja

redis_service_file:
  file:
    - name: /etc/init.d/redisd
    - mode: 755
    - user: root
    - group: root
    - managed
    - template: jinja
    - source: salt://redis/files/redisd

redis_version:
  grains.present:
    - value: {{ redis.redisVersion }}

redis_databases_num:
  grains.present:
    - value: {{ redis.databases }}

include:
  - keepalived.init

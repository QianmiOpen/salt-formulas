{%- from 'memcached/settings.sls' import memcached with context %}

memcached-stop:
  cmd.run:
    - name: kill -9 `cat /tmp/memcached.pid`
    - user: root

memcached-start:
  cmd.run:
    - name: memcached -d -m 1024 -p 11211 -u root -c 1024 -P /tmp/memcached.pid
    - user: root
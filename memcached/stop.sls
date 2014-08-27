{%- from 'memcached/settings.sls' import memcached with context %}

memcached-stop:
  cmd.run:
    - name: kill -9 `cat /tmp/memcached.pid`
    - user: root
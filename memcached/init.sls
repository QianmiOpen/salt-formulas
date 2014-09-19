{%- from 'memcached/settings.sls' import memcached with context %}

get-memcached-package:
  file.managed:
    - name: /root/{{ memcached.memcachedVersion }}{{ memcached.zipType }}
    - source: salt://memcached/pkgs/{{ memcached.memcachedVersion }}{{ memcached.zipType }}
    - saltenv: base
  cmd.run:
    - name: tar -zxf /root/{{ memcached.memcachedVersion }}{{ memcached.zipType }} -C /root 
    - watch:
      - file: get-memcached-package

configure-memcached:
  pkg.installed:
    - names:
      - libevent-devel
  cmd.wait:
    - cwd: /root/{{ memcached.memcachedVersion }}
    - names:
      - ./configure 
    - watch:
      - cmd: get-memcached-package


compile-memcached:
  cmd.wait:
    - cwd: /root/{{ memcached.memcachedVersion }}
    - names:
      - make && make install
    - watch:
      - cmd: configure-memcached
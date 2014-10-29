{%- from 'keepalived/settings.sls' import keepalived with context %}

get-keepalived-package:
  file.managed:
    - name: /root/{{ keepalived.keepalivedVersion }}{{ keepalived.zipType }}
    - source: salt://keepalived/pkgs/{{ keepalived.keepalivedVersion }}{{ keepalived.zipType }}
    - saltenv: base
  cmd.run:
    - name: tar -zxf /root/{{ keepalived.keepalivedVersion }}{{ keepalived.zipType }} -C /root 
    - watch:
      - file: get-keepalived-package

configure-keepalived:
  cmd.wait:
    - cwd: /root/{{ keepalived.keepalivedVersion }}
    - names:
      - ./configure 
    - watch:
      - cmd: get-keepalived-package


compile-keepalived:
  cmd.wait:
    - cwd: /root/{{ keepalived.keepalivedVersion }}
    - names:
      - make && make install
    - watch:
      - cmd: configure-keepalived

keepalived-conf-dir:
  file.directory:
    - name: /etc/keepalived
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

keepalived-script-file:
  file.copy:
    - name: /etc/rc.d/init.d/keepalived
    - source: /usr/local/etc/rc.d/init.d/keepalived
    - force: True
    - makedirs: False

keepalived-sysconfig-file:
  file.copy:
    - name: /etc/sysconfig/keepalived
    - source: /usr/local/etc/sysconfig/keepalived
    - force: True
    - makedirs: False    

keepalived-exec-file:
  file.copy:
    - name: /usr/sbin/keepalived
    - source: /usr/local/sbin/keepalived
    - force: True
    - makedirs: False

keepalived-redis-config:
  file:
    - name: /etc/keepalived/keepalived.conf
    - managed
    - template: jinja
    - source: salt://keepalived/files/keepalived_redis.conf

keepalived-redis-checkfile:
  file:
    - name: /etc/keepalived/check_redis.sh
    - mode: 755
    - user: root
    - group: root
    - managed
    - template: jinja
    - source: salt://keepalived/files/check_redis.sh
keepalived_version:
  grains.present:
    - value: {{ keepalived.keepalivedVersion }}
keepalived_virtual_ipaddress:
  grains.present:
    - value: {{ keepalived.virtual_ipaddress }}

keepalived:
  service:
    - running


{%- from 'keepalived/settings.sls' import keepalived with context %}

get-keepalived-package:
  file.managed:
    - name: /root/{{ keepalived.keepalivedVersion }}{{ keepalived.zipType }}
    - source: salt://keepalived/pkgs/{{ keepalived.keepalivedVersion }}{{ keepalived.zipType }}
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

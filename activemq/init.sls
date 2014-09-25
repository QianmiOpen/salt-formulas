{%- from 'activemq/settings.sls' import activemq with context %}

get-activemq-package:
  file.managed:
    - name: /root/{{ activemq.activemqVersion }}{{ activemq.zipType }}
    - source: salt://activemq/pkgs/{{ activemq.activemqVersion }}{{ activemq.zipType }}
    - saltenv: base
  cmd.run:
    - name: tar -zxf /root/{{ activemq.activemqVersion }}{{ activemq.zipType }} -C /root 
    - watch:
      - file: get-activemq-package
activemq_config:
  file:
    - name: /root/{{ activemq.activemqVersion }}/conf/activemq.xml
    - managed
    - template: jinja
    - source: salt://activemq/files/activemq.xml
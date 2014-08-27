{%- from 'activemq/settings.sls' import activemq with context %}

get-activemq-package:
  file.managed:
    - name: /root/{{ activemq.activemqVersion }}{{ activemq.zipType }}
    - source: salt://activemq/pkgs/{{ activemq.activemqVersion }}{{ activemq.zipType }}
  cmd.run:
    - name: tar -zxf /root/{{ activemq.activemqVersion }}{{ activemq.zipType }} -C /root 
    - watch:
      - file: get-activemq-package
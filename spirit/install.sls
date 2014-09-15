{% from 'spirit/settings.sls' import spirit with context %}

GitPython:
  pkg:
    - installed

salt-master:
  pkg:
    - installed
    - version: 2014.1.10-4.el6
  service.running:
    - enable: True
    - require:
      - pkg: salt-master
      - pkg: GitPython

/etc/salt/master:
  file.managed:
    - source: salt://spirit/files/syndic
    - user: root
    - group: root
    - mode: 640

restart-master:
  service.running:
    - name: salt-master
    - enable: True
    - watch:
      - file: /etc/salt/master

/root/application.conf:
  file.managed:
    - source: salt://spirit/files/application.conf
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - context:
      ipAddress: {{ salt['network.interfaces']()['eth0']['inet'][0]['address'] }}

/root/spirit.jar:
  file.managed:
    - source: salt://spirit/pkgs/{{spirit.package}}
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - context:
      ipAddress: {{ salt['network.interfaces']()['eth0']['inet'][0]['address'] }}

/root/spirit:
  file.managed:
    - source: salt://spirit/files/spirit
    - user: root
    - group: root
    - mode: 700

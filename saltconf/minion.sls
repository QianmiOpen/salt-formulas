salt-minion:
  pkg.latest

salt-install:
  service.running:
    - name: salt-minion
    - enable: True
    - require:
      - pkg: salt-minion

/etc/salt/minion:
  file.managed:
    - source: salt://saltconf/files/minion
    - user: root
    - group: root
    - mode: 640

restart-minion:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion

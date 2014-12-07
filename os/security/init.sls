{%- from 'os/security/settings.sls' import security with context %}

#disable services
# `ls /etc/rc3.d/S*`
# CURSRV=`echo $i|cut -c 15-`
# S02lvm2-monitor  S11portreserve       S26udev-post
# S07iscsid        S12rsyslog           S55sshd
# S08ip6tables     S13iscsi             S80postfix
# S08iptables      S15mdmonitor         S90crond
# S10network       S25blk-availability  S99local
# S11auditd        S25netfs
# crond | irqbalance | microcode_ctl | network | random |  sshd | local | syslog 

# disable iptables
{% set disabledList = ['ip6tables', 'iptables', 'portreserve', 'postfix'] %}
{% for server in disabledList %}
disable-{{ server }}:
  service.dead:
    - name: {{ server }}
    - enable: False
{% endfor %}

# limit
limits_conf:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - '* soft nofile {{ security.limitSoft }}'
      - '* hard nofile {{ security.limitHard }}'

# /etc/profile
/etc/profile:
  file.managed:
    - source: salt://os/security/files/etc/profile
    - user: root
    - group: root
    - mode: 644

# disable selinux ?
# sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config

# LANG
# sed -i -e 's/^LANG=.*/LANG="en_US"/'   /etc/sysconfig/i18n

#init_ssh
/etc/ssh/sshd_config:
  file.managed:
    - source: salt://os/security/files/etc/ssh/sshd_config
    - user: root
    - group: root
    - mode: 600
# service running with watch can restart service
restart-sshd:
  service.running:
    - name: sshd
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config

# optimize kernel
/etc/sysctl.conf:
  file.managed:
    - source: salt://os/security/files/etc/sysctl.conf
    - user: root
    - group: root
    - mode: 644
bridge:
  kmod.present
sysctl:
  cmd.wait:
    - name: /sbin/sysctl -p
    - watch:
      - file: /etc/sysctl.conf
      - kmod: bridge

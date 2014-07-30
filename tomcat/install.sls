{%- from 'tomcat/settings.sls' import tomcat with context %}

tomcat-user:
  user.present:
    - name: tomcat
    - uid: 6666
    - gid: 6666
    - home: {{ tomcat.home }}
    - shell: /bin/bash
    - require:
      - group: tomcat
  group.present:
    - name: tomcat
    - gid: 6666

unpack-tomcat-tarball:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.package }}
    - source: salt://tomcat/pkgs/{{ tomcat.package }}
    - user: tomcat
    - group: tomcat
    - require:
      - user: tomcat-user
  cmd.run:
    - name: tar xf {{ tomcat.home }}/{{ tomcat.package }} -C {{ tomcat.home }}
    - user: tomcat
    - group: tomcat
    - require:
      - file: unpack-tomcat-tarball
  alternatives.install:
    - name: tomcat-home-link
    - user: tomcat
    - group: tomcat
    - link: {{ tomcat.home }}/{{ tomcat.name }}
    - path: {{ tomcat.home }}/{{ tomcat.versionPath }}
    - priority: 30

{% for dir in ['docs', 'examples', 'host-manager', 'manager', 'ROOT'] %}
delete-tomcat-webapps-{{ dir }}:
  file.absent:
    - name: {{ tomcat.appBase }}/{{ dir }}
{% endfor %}

delete-tomcat-users.xml:
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/conf/tomcat-users.xml

copy-env.conf:
  file.managed:
    - name: {{ tomcat.home }}/{{ tomcat.name }}/conf/env.conf
    - source: salt://tomcat/files/env.conf
    - user: tomcat
    - group: tomcat
    - force: False
    - template: jinja
    - defaults:
      tomcatHome: {{ tomcat.home }}

{{ tomcat.home }}/{{ tomcat.name }}/bin/catalina.sh:
  file.blockreplace:
    - marker_start: "# ----- Execute The Requested Command -----"
    - marker_end: "# Bugzilla 37848"
    - content: CATALINA_OPTS=`sed 's/"//g' $CATALINA_BASE/conf/env.conf |awk '/^[^#]/'| tr "\n" ' '`

include:
  - tomcat.env

# move to os.security
# limits_conf:
#   file.append:
#     - name: /etc/security/limits.conf
#     - text:
#       - {{ tomcat.name }} soft nofile {{ tomcat.limitSoft }}
#       - {{ tomcat.name }} hard nofile {{ tomcat.limitHard }}

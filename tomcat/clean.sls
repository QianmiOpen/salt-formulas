{%- from 'tomcat/settings.sls' import tomcat with context %}

delete-tomcat-linked-dir:
  cmd.run:
    - name: "rm -rf `readlink {{ tomcat.home }}/{{ tomcat.name }}`"
    - user: tomcat
    - onlyif: 'test -L {{ tomcat.home }}/{{ tomcat.name }}'
  file.absent:
    - name: {{ tomcat.home }}/{{ tomcat.name }}
    - require:
      - cmd: delete-tomcat-linked-dir

# remove-tomcat-user-group:
#   user.absent:
#     - name: tomcat
#     - purge: True
#     - force: False

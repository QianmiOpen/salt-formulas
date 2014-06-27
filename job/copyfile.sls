{% from 'job/settings.sls' import job with context %}
{% from 'tomcat/settings.sls' import tomcat with context %}

copy-configFile:
  file.recurse:
    - name: {{ tomcat.home }}
    - source: salt://{{ job.path }}
    - user: {{ job.user }}
    - group: {{ job.group }}
    - include_empty: true
#     - template: jinja
#     - defaults:
# {% for key, value in job.iteritems() %}
#       {{ key }}: {{ value }}
# {% endfor %}

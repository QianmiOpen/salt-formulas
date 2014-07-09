{% from 'job/settings.sls' import job with context %}

copy-configFile:
  file.recurse:
    - name: /srv/salt/{{ job.path }}
    - source: salt://{{ job.path }}
    - include_empty: true
#     - template: jinja
#     - defaults:
# {% for key, value in job.iteritems() %}
#       {{ key }}: {{ value }}
# {% endfor %}

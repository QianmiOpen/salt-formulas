{% from 'job/settings.sls' import job with context %}
{% from 'tomcat/settings.sls' import tomcat with context %}

downTar:
  file.managed:
    - name: {{ job.tempFile }}
    - source: {{ job.filePath }}
    - source_hash: {{ job.md5FilePath }}
    - user: {{ job.user }}
    - group: {{ job.group }}
    - makedirs: true
  cmd.run:
    - name: tar xf {{ job.tempFile }} -C {{ tomcat.home }}
    - user: {{ job.user }}
    - group: {{ job.group }}

cleanTempFile:
  file.absent:
    - name: {{ job.tempFile }}

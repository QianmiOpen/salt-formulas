{% from 'job/settings.sls' import job with context %}

Git fileserver update:
  cmd.run:
    - name: salt-run fileserver.update
    - stateful: True

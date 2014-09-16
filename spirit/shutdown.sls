{% from 'spirit/settings.sls' import spirit with context %}

spirit-shutdown:
  cmd.run:
    - name: service spiritd stop
    - user: root

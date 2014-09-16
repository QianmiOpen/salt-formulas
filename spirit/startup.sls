{% from 'spirit/settings.sls' import spirit with context %}

spirit-start:
  cmd.run:
    - name: service spiritd start
    - user: root

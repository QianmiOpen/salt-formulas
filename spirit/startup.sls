{% from 'spirit/settings.sls' import spirit with context %}

spirit_startup:
  cmd.run:
    - name: sh {{ spirit.home }}/spirit
    - user: root
    - cwd: /root
    - unless: 'ps -p `cat {{ spirit.home }}/{{ spirit.pid }}`'

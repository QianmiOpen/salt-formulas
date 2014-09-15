{% from 'spirit/settings.sls' import spirit with context %}

spirit_shutdown:
  cmd.run:
    - name: kill `cat {{ spirit.home }}/{{ spirit.pid }}`
    - user: root
    - cwd: /root
    - onlyif: 'test -e {{ spirit.home }}/{{ spirit.pid }}'

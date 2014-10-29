{%- from 'autotest/settings.sls' import autotest with context %}

autotest-user:
  user.present:
    - name: autotest
    - uid: 6667
    - gid: 6667
    - home: {{ autotest.home }}
    - shell: /bin/bash
    - require:
      - group: autotest
  group.present:
    - name: autotest
    - gid: 6667

{{ autotest.home }}:
  file.directory:
    - user: autotest
    - group: autotest
    - mode: 755
    - makedirs: True
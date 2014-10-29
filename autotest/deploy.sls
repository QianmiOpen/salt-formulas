{% from 'autotest/settings.sls' import autotest with context %}

delete-appbase:
  file.absent:
    - name: {{ autotest.home }}/*

include:
  - autotest.user

git:
  pkg:
    - installed

git-init:
  cmd.run:
    - cwd: {{ autotest.home }}
    - name: git clone {{ autotest.gitUrl }} {{ autotest.appHome }}
    - user: autotest
    - require:
      - pkg: git




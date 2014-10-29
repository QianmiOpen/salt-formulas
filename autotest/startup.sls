{%- from 'autotest/settings.sls' import autotest with context %}

autotest_startup:
  cmd.run:
    - cwd: {{ autotest.appHome }}
    - name: sbt cucumber
    - user: autotest

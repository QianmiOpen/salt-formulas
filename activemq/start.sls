{%- from 'activemq/settings.sls' import activemq with context %}

activemq-start:
  cmd.run:
    - name: {{ activemq.installPath }}/bin/activemq start
    - user: root
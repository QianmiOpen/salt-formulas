{%- from 'java/settings.sls' import java with context %}

delete-jdk-linked-dir:
  cmd.run:
    - name: "rm -rf `readlink {{ java.home }}`"
    - user: root
    - onlyif: 'test -e {{ java.home }}'
  file.absent:
    - name: {{ java.home }}
    - require:
      - cmd: delete-jdk-linked-dir

delete-profile-file:
  file.absent:
    - name: /etc/profile.d/java.sh

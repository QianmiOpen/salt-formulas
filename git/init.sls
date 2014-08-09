{%- from 'git/settings.sls' import git with context %}

git:
  pkg:
    - installed

{{ git.home }}/.gitignore:
  file.managed:
    - source: salt://git/files/.gitignore
    - user: {{ git.user }}
    - group: {{ git.group }}
    - mode: 644
    - require:
      - pkg: git

git-init:
  cmd.run:
    - name: git init
    - user: {{ git.user }}
    - cwd: {{ git.home }}
    - unless: 'test -e {{ git.home }}/.git'


{%- from 'git/settings.sls' import git with context %}

include:
  - git.init

checkout-tag:
  cmd.run:
    - name: "git status | grep -E  '^#.+deleted:' | awk '{print($3)}' | xargs git rm"
    - user: {{ git.user }}
    - cwd: {{ git.home }}
    - unless: "test `git status | grep -E  '^#.+deleted:' | awk '{print($3)}' | wc -l` -eq 0"

create-tag:
  cmd.run:
    - name: |
        git add .
        git commit -m '{{ git.commitMessage }}'
        git tag {{ git.tagName }}
    - user: {{ git.user }}
    - cwd: {{ git.home }}
    - require:
      - cmd: git-delete
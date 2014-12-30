{%- from 'elasticsearch/settings.sls' import elasticsearch with context %}

tar:
  pkg.installed

elasticsearch_bash_profile:
  file.managed:
    - name: {{ elasticsearch.base }}/.bash_profile
    - template: jinja
    - source: salt://elasticsearch/files/bash_profile
    - user: elasticsearch

unpack-elasticsearch-tarball:
  file.managed:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.package }}
    - source: salt://elasticsearch/pkgs/{{ elasticsearch.package }}
    - saltenv: base
    - user: elasticsearch
    - group: elasticsearch
  cmd.run:
    - name: tar xf {{ elasticsearch.base }}/{{ elasticsearch.package }} -C {{ elasticsearch.base }}
    - user: elasticsearch
    - require:
      - pkg: tar
      - file: unpack-elasticsearch-tarball

elasticsearch-logs:
  file.directory:
    - name: {{ elasticsearch.home }}/logs
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - cmd: unpack-elasticsearch-tarball     

elasticsearch_config:
  file.managed:
    - name: {{ elasticsearch.home }}/config/elasticsearch.yml
    - template: jinja
    - source: salt://elasticsearch/files/elasticsearch.yml
    - user: elasticsearch

copy-ik-dir:
  file.recurse:
    - name: {{ elasticsearch.home }}/config/ik
    - source: salt://elasticsearch/files/ik
    - makedirs: true
    - user: elasticsearch
    - group: elasticsearch

elasticsearch_appfile:
  file.managed:
    - name: {{ elasticsearch.home }}/bin/elasticsearch
    - template: jinja
    - source: salt://elasticsearch/files/elasticsearch
    - user: elasticsearch

unpack_service_tarball:
  file.managed:
    - name: {{ elasticsearch.base }}/service.tar.gz
    - source: salt://elasticsearch/pkgs/service.tar.gz
    - saltenv: base
    - user: elasticsearch
    - group: elasticsearch
  cmd.run:
    - name: tar xf {{ elasticsearch.base }}/service.tar.gz -C {{ elasticsearch.home }}/bin
    - user: elasticsearch
    - require:
      - pkg: tar
      - file: unpack_service_tarball

elasticsearch_service_config_add_xmod:
  file.managed:
    - name: {{ elasticsearch.home }}/bin/service/elasticsearch.conf
    - source: salt://elasticsearch/files/elasticsearch.conf
    - template: jinja
    - user: elasticsearch
    - require:
      - cmd: unpack_service_tarball
  cmd.run:
    - name: chmod +x *
    - cwd: {{ elasticsearch.home }}/bin/service/exec
    - user: elasticsearch
    - require:
      - file: elasticsearch_service_config_add_xmod

symlink-elasticsearch:
  file.symlink:
    - name: {{ elasticsearch.base }}/{{ elasticsearch.prefix }}
    - target: {{ elasticsearch.home }}
    - user: elasticsearch
    - group: elasticsearch      

{{ elasticsearch.base }}/ES_backup:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch      
    - mode: 755
    - makedirs: True
  mount.mounted:
    - device: {{ elasticsearch.nfsServer }}:/oflogs/ES_backup
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True
    - require:
      - pkg: nfs-utils

include:
  - elasticsearch.user
{%- from 'tengine/settings.sls' import tengine with context %}

conf-domains-dir:
  file.directory:
    - name: {{ tengine.installPath }}/conf/domains
    - mode: 755
    - user: root
    - group: root

domains-domain-dir:
  file.directory:
    - name: {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}
    - mode: 755
    - user: root
    - group: root

configue-server-template-tmp:
  file.managed:
    - name: {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.server.template
    - source: salt://tengine/files/server.template.conf
    - replace: true
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - template: jinja
    - defaults:
        tengine: {{ tengine|json }}

configue-upstream-head:
  file.managed:
    - name: {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.head
    - source: salt://tengine/files/upstream.head
    - replace: true
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - template: jinja
    - defaults:
        tengine: {{ tengine|json }}

#增加一个文件存放ip_hash判断的配置，并增加在文件合并中
configue-upstream-iphash:
  file.managed:
    - name: {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.iphash
    - source: salt://tengine/files/upstream.iphash
    - replace: true
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - template: jinja
    - defaults:
        tengine: {{ tengine|json }}

configue-upstream-serverip:
  file.managed:
    - name: {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.{{ tengine.ip }}.list
    - source: salt://tengine/files/upstream.serverip.list
    - replace: true
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - template: jinja
    - defaults:
        tengine: {{ tengine|json }}

configue-upstream-tail:
  file.managed:
    - name: {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.tail
    - source: salt://tengine/files/upstream.tail
    - replace: true
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - template: jinja
    - defaults:
        tengine: {{ tengine|json }}

merge-server-template:
  cmd.run:
    - name: cat {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.head {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.iphash {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.*.list {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.upstream.tail {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.server.template > {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.conf
    - template: jinja
    - require:
      - file: conf-domains-dir
      - file: domains-domain-dir
      - file: configue-server-template-tmp
      - file: configue-upstream-head
      - file: configue-upstream-iphash
      - file: configue-upstream-serverip
      - file: configue-upstream-tail

replace-domain-file:
  cmd.run:
    - name: mv -f {{ tengine.installPath }}/conf/domains/{{ tengine.domain }}/{{ tengine.domain }}.conf {{ tengine.installPath }}/conf/servers/{{ tengine.domain }}.conf
    - template: jinja
    - require:
      - cmd: merge-server-template    

{% from 'webapp/settings.sls' import webapp with context %}

{% if salt['grains.get']('virtual')  == 'VMware' %}
nfs-utils:
  pkg:
    - installed

unmount-nfs-dirs:
  cmd.run:
    - name: "mount -t `mount |tail -1 |awk '{print $5}'` | awk '{print $3}' | xargs umount -l"
    - user: root
    - group: root
    - unless: "test `mount |tail -1 |grep logs |grep nfs |awk '{print $5}'| wc -l` -eq 0"
    - require:
      - pkg: nfs-utils

{% if  webapp.logHome  == '/oflogs' %}
{{ webapp.logHome }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 755
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsServer }}:{{ webapp.logHome }}
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True
    - require:
      - pkg: nfs-utils

unmount-oflogs:
  file.directory:
    - name: {{ webapp.logHome }}/{{ webapp.projectName }}
    - mode: 777
    - makedirs: True
  mount.unmounted:
    - name: {{ webapp.logHome }}
    - persist: False

{{ webapp.logHome }}/{{ webapp.projectName }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 777
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsServer }}:{{ webapp.logHome }}/{{ webapp.projectName }}
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True
{% elif  webapp.logHome  == '/qmlogs' %}
{{ webapp.logHome }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 755
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsServer }}:{{ webapp.volHome }}{{ webapp.logHome }}
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True
    - require:
      - pkg: nfs-utils

unmount-oflogs:
  file.directory:
    - name: {{ webapp.logHome }}/{{ webapp.projectName }}
    - mode: 777
    - makedirs: True
  mount.unmounted:
    - name: {{ webapp.logHome }}
    - persist: False

{{ webapp.logHome }}/{{ webapp.projectName }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 777
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsServer }}:{{ webapp.volHome }}{{ webapp.logHome }}/{{ webapp.projectName }}
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True
{% endif %}

webapp:
  grainsdict.present:
    - value: {{ webapp|json }}
    - require:
      - cmd: unmount-nfs-dirs
      - file: {{ webapp.logHome }}
      - mount: {{ webapp.logHome }}
      - file: unmount-oflogs
      - mount: unmount-oflogs
      - file: {{ webapp.logHome }}/{{ webapp.projectName }}
      - mount: {{ webapp.logHome }}/{{ webapp.projectName }}

{% elif salt['grains.get']('virtual')  == 'physical' %}
{{ webapp.logHome }}/{{ webapp.projectName }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 777
    - makedirs: True

webapp:
  grainsdict.present:
    - value: {{ webapp|json }}
    - require:
      - file: {{ webapp.logHome }}/{{ webapp.projectName }}
{% endif %}    
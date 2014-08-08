{% from 'webapp/settings.sls' import webapp with context %}

nfs-utils:
  pkg:
    - installed

unmount-nfs-dirs:
  cmd.run:
    - name: "mount -t nfs | awk '{print $3}' | xargs umount -l"
    - user: root
    - group: root
    - require:
      - pkg: nfs-utils

/oflogs:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 755
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsServer }}:/oflogs
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True
    - require:
      - pkg: nfs-utils

unmount-oflogs:
  file.directory:
    - name: /oflogs/{{ webapp.projectName }}
    - mode: 777
    - makedirs: True
  mount.unmounted:
    - name: /oflogs
    - persist: False

/oflogs/{{ webapp.projectName }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 777
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsServer }}:/oflogs/{{ webapp.projectName }}
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True

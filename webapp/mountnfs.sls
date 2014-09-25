{% from 'webapp/settings.sls' import webapp with context %}

{{ webapp.serverDir }}:
  file.directory:
    - user: tomcat
    - group: tomcat
    - mode: 777
    - makedirs: True
  mount.mounted:
    - device: {{ webapp.nfsDir }}
    - fstype: nfs
    - opts: nosuid,nodev,rw,bg,soft,nolock
    - persist: True

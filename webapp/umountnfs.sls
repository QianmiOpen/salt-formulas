{% from 'webapp/settings.sls' import webapp with context %}

unmount-nfs:
  mount.unmounted:
    cmd.run:
    - name: "umount -l {{ webapp.nfsDir }}"
    - user: root
    - group: root

{% from 'webapp/settings.sls' import webapp with context %}

unmount-nfs:
  mount.unmounted:
    cmd.run:
    - name: "mount -t nfs | grep "{{ webapp.nfsDir }}" | awk '{print $3}' | xargs umount -l "
    - user: root
    - group: root

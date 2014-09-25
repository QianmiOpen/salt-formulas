{% from 'webapp/settings.sls' import webapp with context %}

unmount-nfs:
  mount.unmounted:
    - name: {{ webapp.nfsDir }}
    - persist: False
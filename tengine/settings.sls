{% set p  = salt['pillar.get']('tengine', {}) %}

{% set tengine = {} %}
{%- do tengine.update({'home'        : '/root',
                       'installPath' : '/tengine',
                       'tengine'     : 'tengine-2.0.3',
                       'ssl'         : 'openssl-1.0.1h',
                       'nginxSticky' : 'nginx-sticky-module-1.1',
                       'nginxCache'  : 'ngx_cache_purge-2.1',
                       'zipType'     : '.tar.gz',
                       'domain'      : 'www.1000.com',
                       'serverNameList' : 'www.1000.como www.ofcard.com',
                       'ip'          : '172.19.0.200',
                       'port'        : '8080',
                       'isMaster'    : True,
                       'isIPhash'    : True                       
                      }) %}

{% for key, value in tengine.iteritems() %}
{% do tengine.update({key: p.get(key, value)}) %}
{% endfor %}

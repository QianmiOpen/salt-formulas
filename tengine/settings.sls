{% set p  = salt['pillar.get']('tengine', {}) %}

{% set tengine = {} %}
{%- do tengine.update({'home'        : '/root',
                       'installPath' : '/tengine',
                       'tengine'     : 'tengine-2.0.3',
                       'ssl'         : 'openssl-1.0.1h',
                       'nginxSticky' : 'nginx-sticky-module-1.1',
                       'nginxCache'  : 'ngx_cache_purge-2.1',
                       'zipType'     : '.tar.gz'
                      }) %}

{% for key, value in tengine.iteritems() %}
{% do tengine.update({key: p.get(key, value)}) %}
{% endfor %}

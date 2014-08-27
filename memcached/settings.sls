{% set p  = salt['pillar.get']('memcached', {}) %}

{% set memcached = {} %}
{%- do memcached.update({'home'             : '/memcached',
                     'memcachedVersion'     : 'memcached-1.4.20',
                     'zipType'          : '.tar.gz',
                     'installPath'      : '/usr/local/bin'
                    }) %}

{% for key, value in memcached.iteritems() %}
{% do memcached.update({key: p.get(key, value)}) %}
{% endfor %}

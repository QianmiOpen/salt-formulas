{% set p  = salt['pillar.get']('keepalived', {}) %}

{% set keepalived = {} %}
{%- do keepalived.update({'home'             : '/keepalived',
                     'keepalivedVersion'     : 'keepalived-1.2.13',
                     'zipType'               : '.tar.gz',
                     'virtual_ipaddress'     : '172.19.22.50'
                    }) %}

{% for key, value in keepalived.iteritems() %}
{% do keepalived.update({key: p.get(key, value)}) %}
{% endfor %}
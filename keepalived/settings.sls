{% set p  = salt['pillar.get']('keepalived', {}) %}

{% set keepalived = {} %}
{%- do keepalived.update({'home'             : '/keepalived',
                     'keepalivedVersion'     : 'keepalived-1.2.13',
                     'zipType'               : '.tar.gz',
                     'virtual_ipaddress'     : '172.19.22.50',
                     'virtual_router_id'     : '166',
                     'priority_master'       : '205',
                     'priority_backup'       : '200',
                     'nopreempt_master'      : 'nopreempt',
                     'nopreempt_backup'      : '',
                     'isMaster'              : True
                    }) %}

{% for key, value in keepalived.iteritems() %}
{% do keepalived.update({key: p.get(key, value)}) %}
{% endfor %}
{% set p  = salt['pillar.get']('security', {}) %}

{% set security = {} %}
{%- do security.update({'limitSoft'           : 65535,
                        'limitHard'           : 65535
                      }) %}

{% for key, value in security.iteritems() %}
{% do security.update({key: p.get(key, value)}) %}
{% endfor %}

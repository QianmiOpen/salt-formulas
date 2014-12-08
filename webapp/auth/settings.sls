{% set p  = salt['pillar.get']('auth', {}) %}

{% set auth = {} %}
{%- do auth.update({'users'           : ''
                    }) %}

{% for key, value in auth.iteritems() %}
{% do auth.update({key: p.get(key, value)}) %}
{% endfor %}

{% set p  = salt['pillar.get']('activemq', {}) %}

{% set activemq = {} %}
{%- do activemq.update({'home'             : '/activemq',
                     'activemqVersion'     : 'apache-activemq-5.9.0',
                     'zipType'          : '.tar.gz',
                     'installPath'      : '/root/apache-activemq-5.9.0'
                    }) %}

{% for key, value in activemq.iteritems() %}
{% do activemq.update({key: p.get(key, value)}) %}
{% endfor %}
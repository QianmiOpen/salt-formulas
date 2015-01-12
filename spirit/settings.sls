{% set p  = salt['pillar.get']('spirit', {}) %}

{% set spirit = {} %}
{%- do spirit.update({'prefix'        : 'spirit_',
                      'version'       : '2.10-1.4.3',
                      'suffix'        : '-one-jar.jar',
                      'home'          : '/opt/spirit'
                      }) %}

{% for key, value in spirit.iteritems() %}
{% do spirit.update({key: p.get(key, value)}) %}
{% endfor %}

{% set package = p.get('package', spirit.prefix ~ spirit.version ~ spirit.suffix) %}

{%- do spirit.update({'package'        : package
                      }) %}

{% set p  = salt['pillar.get']('spirit', {}) %}

{% set spirit = {} %}
{%- do spirit.update({'prefix'        : 'spirit_',
                      'version'       : '2.10-1.3.1',
                      'suffix'        : '-one-jar.jar'
                      }) %}

{% for key, value in spirit.iteritems() %}
{% do spirit.update({key: p.get(key, value)}) %}
{% endfor %}

{% set package = p.get('package', spirit.prefix ~ spirit.version ~ spirit.suffix) %}

{%- do spirit.update({'package'        : package
                      }) %}

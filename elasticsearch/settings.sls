{% set p  = salt['pillar.get']('elasticsearch', {}) %}

{% set elasticsearch = {} %}
{%- do elasticsearch.update({'home'        : '/opt/elasticsearch',
                             'base'        : '/opt',
                             'prefix'      : 'elasticsearch',
                             'version'     : '1.2.4',
                             'fileType'    : 'tar.gz',
                             'nodename'    : '192.1168.0.1',
                             'clustername' : 'elasticsearch'
                             }) %}

{% for key, value in elasticsearch.iteritems() %}
{% do elasticsearch.update({key: p.get(key, value)}) %}
{% endfor %}

{% set package = p.get('package', elasticsearch.prefix ~ '-' ~ elasticsearch.version ~ '.' ~ elasticsearch.fileType) %}

{%- do elasticsearch.update({'package'    : package
                             }) %}
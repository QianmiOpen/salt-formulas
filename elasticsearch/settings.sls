{% set p  = salt['pillar.get']('elasticsearch', {}) %}

{% set elasticsearch = {} %}
{%- do elasticsearch.update({'home'        : '/opt/elasticsearch',
                             'base'        : '/opt',
                             'prefix'      : 'elasticsearch',
                             'version'     : '1.1.1',
                             'fileType'    : 'tar.gz'
                             }) %}

{% for key, value in elasticsearch.iteritems() %}
{% do elasticsearch.update({key: p.get(key, value)}) %}
{% endfor %}

{% set package = p.get('package', elasticsearch.prefix ~ '-' ~ elasticsearch.version ~ '.' ~ elasticsearch.fileType) %}

{%- do elasticsearch.update({'package'    : package
                             }) %}
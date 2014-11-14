{% set p  = salt['pillar.get']('elasticsearch', {}) %}

{% set elasticsearch = {} %}
{%- do elasticsearch.update({'base'        : '/home/elasticsearch',
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
{% set home = p.get('home', elasticsearch.base ~ '/' ~ elasticsearch.prefix ~ '-' ~ elasticsearch.version) %}

{%- do elasticsearch.update({'package'    : package,
                             'home'       : home
                             }) %}
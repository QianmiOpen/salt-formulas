{% set p  = salt['pillar.get']('elasticsearch', {}) %}

{% set elasticsearch = {} %}
{%- do elasticsearch.update({'base'               : '/home/elasticsearch',
                             'prefix'             : 'elasticsearch',
                             'version'            : '1.4.2',
                             'fileType'           : 'tar.gz',
                             'nodename'           : '192.1168.0.1',
                             'clustername'        : 'elasticsearch',
                             'number_of_shards'   : '5',
                             'number_of_replicas' : '1',
                             'nfsServer'          : '192.168.111.210'
                             }) %}

{% for key, value in elasticsearch.iteritems() %}
{% do elasticsearch.update({key: p.get(key, value)}) %}
{% endfor %}

{% set package = p.get('package', elasticsearch.prefix ~ '-' ~ elasticsearch.version ~ '.' ~ elasticsearch.fileType) %}
{% set home = p.get('home', elasticsearch.base ~ '/' ~ elasticsearch.prefix ~ '-' ~ elasticsearch.version) %}

{%- do elasticsearch.update({'package'    : package,
                             'home'       : home
                             }) %}
{% set p  = salt['pillar.get']('logstash', {}) %}

{% set logstash = {} %}
{%- do logstash.update({'home'        : '/home/logstash',
                        'base'        : '/opt',
                        'prefix'      : 'logstash',
                        'version'     : '1.4.2',
                        'fileType'    : 'tar.gz',
                        'redisIPList' : '192.168.65.1,192.168.65.2,192.168.65.3',
                        'redisPort'   : '6379',
                        'hostIP'      : '172.168.0.1',
                        'clustername' : 'elasticsearch'
                        }) %}

{% for key, value in logstash.iteritems() %}
{% do logstash.update({key: p.get(key, value)}) %}
{% endfor %}

{% set package = p.get('package', logstash.prefix ~ '-' ~ logstash.version ~ '.' ~ logstash.fileType) %}

{%- do logstash.update({'package'    : package
                        }) %}
{% set p  = salt['pillar.get']('redis', {}) %}

{% set redis = {} %}
{%- do redis.update({'home'             : '/redis',
                     'redisVersion'     : 'redis-2.8.13',
                     'zipType'          : '.tar.gz',
                     'installPath'      : '/usr/local/bin'
                    }) %}

{% for key, value in redis.iteritems() %}
{% do redis.update({key: p.get(key, value)}) %}
{% endfor %}

{% set p  = salt['pillar.get']('zookeeper', {}) %}

{% set zookeeper = {} %}
{%- do zookeeper.update({'home'             : '/zookeeper',
                     'zookeeperVersion'     : 'zookeeper-3.4.6',
                     'zipType'          : '.tar.gz'
                    }) %}

{% for key, value in zookeeper.iteritems() %}
{% do zookeeper.update({key: p.get(key, value)}) %}
{% endfor %}
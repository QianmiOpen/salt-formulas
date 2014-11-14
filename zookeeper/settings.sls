{% set p  = salt['pillar.get']('zookeeper', {}) %}

{% set zookeeper = {} %}
{%- do zookeeper.update({'home'             : '/home/zookeeper',
                     'zookeeperVersion'     : 'zookeeper-3.4.6',
                     'zkdataPath'           : 'zk_data',
                     'zipType'              : '.tar.gz',
                     'hostslist'            : '192.168.65.1,192.168.65.2,192.168.65.3',
                     'hostip'               : '192.168.65.2'
                    }) %}

{% for key, value in zookeeper.iteritems() %}
{% do zookeeper.update({key: p.get(key, value)}) %}
{% endfor %}
{% set p = salt['pillar.get']('autotest', {}) %}

{% set autotest = {} %}
{%- do autotest.update({
                        'gitUrl'     : 'http://git.dev.ofpay.com/git/of855/smart_an.git',
                        'home'       : '/home/autotest',
                        'appHome'    : '/home/autotest/myAutoTest'
                      }) %}

{% for key, value in autotest.iteritems() %}
{% do autotest.update({key: p.get(key, value)}) %}
{% endfor %}



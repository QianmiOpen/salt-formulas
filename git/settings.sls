{% set p  = salt['pillar.get']('git', {}) %}

{% set git = {} %}
{%- do git.update({'home'        : '/home/tomcat',
                   'user'        : 'tomcat',
                   'group'       : 'tomcat',
                   'commitMessage': 'testMsg',
                   'tagName'       : 'testTag',
                  }) %}

{% for key, value in git.iteritems() %}
{% do git.update({key: p.get(key, value)}) %}
{% endfor %}

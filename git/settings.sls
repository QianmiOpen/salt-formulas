{% set p  = salt['pillar.get']('git', {}) %}

{% set git = {} %}
{%- do git.update({'home'        : '/home/tomcat',
                   'user'        : 'tomcat',
                   'group'       : 'tomcat',
                   'commitMessage': 'testMsg',
                   'version'     : '1.1.0-RELEASE',
                   'taskId'      : '0',
                   'stage'       : 'after',
                   'tagName'     : 'testTag',
                  }) %}

{% for key, value in git.iteritems() %}
{% do git.update({key: p.get(key, value)}) %}
{% endfor %}

{% set tagName    = p.get('tagName', git.taskId ~ '-' ~ git.stage ~ '-' git.version) %}

{%- do git.update({'tagName'    : tagName,
                   }) %}

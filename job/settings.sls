{% set p  = salt['pillar.get']('job', {}) %}

{% set job = {} %}
{%- do job.update({'basePath'       : 'work',
                   'appName'        : 'cardbase',
                   'id'             : '0',
                   'filePath'       : 'files',
                   'user'           : 'tomcat',
                   'group'          : 'tomcat'
                   }) %}

{% for key, value in job.iteritems() %}
{% do job.update({key: p.get(key, value)}) %}
{% endfor %}

{% set path = p.get('path', job.basePath ~ '/' ~ job.appName ~ '/' ~ job.id ~ '/' ~ job.filePath) %}

{%- do job.update({'path'        : path
                   }) %}

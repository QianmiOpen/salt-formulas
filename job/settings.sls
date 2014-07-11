{% set p  = salt['pillar.get']('job', {}) %}

{% set job = {} %}
{%- do job.update({'baseUrl'        : 'http://bugatti.dev.ofpay.com',
                   'basePath'       : 'pkgs',
                   'id'             : '0',
                   'confFileName'   : 'hello',
                   'type'           : '.tar.gz',
                   'user'           : 'tomcat',
                   'group'          : 'tomcat'
                   }) %}

# {% for key, value in p.iteritems() %}
# {% do job.update({key: value}) %}
# {% endfor %}

{% for key, value in job.iteritems() %}
{% do job.update({key: p.get(key, value)}) %}
{% endfor %}

{% set path = p.get('path', job.baseUrl ~ '/' ~ job.basePath ~ '/' ~ job.id ~ '/' ~ job.confFileName) %}

{%- do job.update({'path'        : path,
                   'filePath'    : path ~ job.type,
                   'md5FilePath' : path ~ job.type ~ '.md5',
                   'tempDir'     : '/home/pkgs/' ~ job.confFileName,
                   'tempFile'    : '/home/pkgs/' ~ job.confFileName ~ job.type
                   }) %}

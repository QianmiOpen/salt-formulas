{% set p  = salt['pillar.get']('java', {}) %}

{% set java = {} %}
{%- do java.update({'home'        : '/usr/lib/java',
                    'prefix'      : 'jdk',
                    'version'     : '1.7.0_60',
                    'installPath' : '/usr/share/java',
                    'package'     : 'jdk-7u60-linux-x64.tar.gz'
                    }) %}

{% for key, value in java.iteritems() %}
{% do java.update({key: p.get(key, value)}) %}
{% endfor %}

{% set versionPath    = p.get('versionPath', java.prefix + java.version) %}
{% set realHome       = java.installPath + '/' + versionPath %}

{%- do java.update({'versionPath'    : versionPath,
                    'realHome'       : realHome
                    }) %}
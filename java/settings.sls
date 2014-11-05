{% set p  = salt['pillar.get']('java', {}) %}

{% set java = {} %}

{% set packageConf = {
      'jdk7': {
        'package': 'jdk-7u60-linux-x64.tar.gz',
        'jdkversion': 'jdk1.7.0_60'
      },
      'jdk6': {
        'package': 'jdk-6u45-linux-x64.tar.gz',
        'jdkversion': 'jdk1.6.0_45'
      }
    }
  %}

{%- do java.update({'home'           : '/usr/lib/java',
                    'version'        : 'jdk7',
                    'installPath'    : '/usr/share/java'
                    }) %}

{% for key, value in java.iteritems() %}
{% do java.update({key: p.get(key, value)}) %}
{% endfor %}

{% set versionPath    = p.get('versionPath', packageConf[java.version].jdkversion) %}
{% set package        = p.get('package',  packageConf[java.version].package) %}
{% set realHome       = java.installPath + '/' + versionPath %}


{%- do java.update({'versionPath'    : versionPath,
                    'realHome'       : realHome,
                    'package'        : package
                    }) %}
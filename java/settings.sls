{% set p  = salt['pillar.get']('java', {}) %}
{% set g  = salt['grains.get']('java', {}) %}

{% set java = {} %}

{% set packageConf = {
      'jdk7': {
        'package': 'jdk-7u71-linux-x64.tar.gz',
        'jdkversion': '1.7.0_71'
      },
      'jdk6': {
        'package': 'jdk-6u45-linux-x64.tar.gz',
        'jdkversion': '1.6.0_45'
      }
    }
  %}

{%- do java.update({'home'           : '/usr/lib/java',
                    'version'        : 'jdk7',
                    'installPath'    : '/usr/share/java',
                    'forceInstall'   : false
                    }) %}

{% for key, value in java.iteritems() %}
{% do java.update({key: p.get(key, g.get(key, value))}) %}
{% endfor %}

{% set versionPath    = p.get('versionPath', 'jdk' ~ packageConf[java.version].jdkversion) %}
{% set package        = p.get('package',  packageConf[java.version].package) %}
{% set realHome       = java.installPath + '/' + versionPath %}


{%- do java.update({'versionPath'    : versionPath,
                    'realHome'       : realHome,
                    'package'        : package,
                    'jdkVersion'     : packageConf[java.version].jdkversion
                    }) %}

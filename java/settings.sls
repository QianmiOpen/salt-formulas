{% set p  = salt['pillar.get']('java', {}) %}
{% set g  = salt['grains.get']('java', {}) %}

{% set java = {} %}

{% set packageConf = {
      'jdk7': {
        'package': 'jdk-7u71-linux-x64.tar.gz',
        'jdkVersion': '1.7.0_71'
      },
      'jdk6': {
        'package': 'jdk-6u45-linux-x64.tar.gz',
        'jdkVersion': '1.6.0_45'
      }
    }
  %}

{%- do java.update({'home'           : '/usr/lib/java',
                    'version'        : 'jdk7',
                    'installPath'    : '/usr/share/java',
                    'forceInstall'   : false,
                    'md5'            : '1234567890'
                    }) %}

{% for key, value in java.iteritems() %}
{% do java.update({key: p.get(key, value)}) %}
{% endfor %}

{% do java.update({'jdkVersion'     : packageConf[java.version].jdkVersion}) %}

{% if g.get('jdkVersion', 'none') != java.jdkVersion %}
{% do java.update({'forceInstall': true}) %}
{% endif %}

{% set versionPath    = p.get('versionPath', 'jdk' ~ java.jdkVersion) %}
{% set package        = p.get('package',  packageConf[java.version].package) %}
{% set realHome       = java.installPath + '/' + versionPath %}

{%- do java.update({'versionPath'    : versionPath,
                    'realHome'       : realHome,
                    'package'        : package
                    }) %}

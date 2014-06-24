{% set p  = salt['pillar.get']('java', {}) %}

{% set default_home = '/usr/lib/java' %}
{% set default_prefix        = 'jdk' %}
{% set default_version       = '1.7.0_60' %}
{% set default_installPath   = '/usr/share/java' %}
{% set default_package       = 'jdk-7u60-linux-x64.tar.gz' %}

{% set home           = p.get('home', default_home) %}
{% set version        = p.get('version', default_version) %}
{% set prefix         = p.get('prefix', default_prefix) %}
{% set versionPath    = p.get('versionPath', prefix + version) %}
{% set installPath    = p.get('installPath', default_installPath) %}
{% set realHome       = installPath + '/' + versionPath %}
{% set package        = p.get('package', default_package) %}

{% set java = {} %}
{%- do java.update({'home'           : home,
                    'version'        : version,
                    'versionPath'    : versionPath,
                    'installPath'    : installPath,
                    'realHome'       : realHome,
                    'package'        : package
                    }) %}

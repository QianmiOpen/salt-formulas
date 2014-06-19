{% set p  = salt['pillar.get']('java', {}) %}
{% set g  = salt['grains.get']('java', {}) %}

{%- set java_home      = salt['grains.get']('java_home', salt['pillar.get']('java_home', '/usr/lib/java')) %}

{%- set default_version_name = 'jdk1.7.0_55' %}
{%- set default_prefix       = '/usr/share/java' %}
{%- set default_package      = 'jdk-7u55-linux-x64.gz' %}
{%- set default_init_env     = True %}

{%- set version_name   = g.get('version_name', p.get('version_name', default_version_name)) %}
{%- set prefix         = g.get('prefix', p.get('prefix', default_prefix)) %}
{%- set java_real_home = prefix + '/' + version_name %}
{%- set package        = g.get('package', p.get('package', default_package)) %}
{%- set init_env       = g.get('init_env', p.get('init_env', default_init_env)) %}

{%- set java = {} %}
{%- do java.update( { 'version_name'   : version_name,
                      'java_home'      : java_home,
                      'prefix'         : prefix,
                      'java_real_home' : java_real_home,
                      'package'        : package,
                      'init_env'       : init_env
                  }) %}
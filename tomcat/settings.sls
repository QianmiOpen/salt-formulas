{% set p  = salt['pillar.get']('tomcat', {}) %}

{% set default_home = '/home/tomcat' %}
{% set default_name = 'tomcat' %}
{% set default_packagePrefix = 'apache-tomcat-' %}
{% set default_version = '7.0.54' %}
{% set default_packageSuffix = '.tar.gz' %}

{% set default_limitSoft = 64000 %}
{% set default_limitHard = 64000 %}

{% set default_hostName = 'localhost' %}
{% set default_appBase  = default_home + '/' + default_name + '/webapps' %}
{% set default_path     = '/' %}
{% set default_appName  = 'server' %}
{% set default_unpackWARs = 'false' %}
{% set default_autoDeploy = 'false' %}
{% set default_deployXML  = 'false' %}
{% set default_deployOnStartup = 'false' %}
{% set default_reloadable = 'false' %}
{% set default_privileged = 'true' %}
{% set default_debug = '0' %}


{% set home        = p.get('home', default_home) %}
{% set name        = p.get('name', default_name) %}
{% set packagePrefix = p.get('packagePrefix', default_packagePrefix) %}
{% set version     = p.get('version', default_version) %}
{% set packageSuffix = p.get('packageSuffix', default_packageSuffix) %}

{% set package     = p.get('package', packagePrefix + version + packageSuffix) %}
{% set versionPath = p.get('versionPath', packagePrefix + version) %}

{% set limitSoft = p.get('limitSoft', default_limitSoft) %}
{% set limitHard = p.get('limitHard', default_limitHard) %}

{% set hostName   = p.get('hostName', default_hostName) %}
{% set appBase    = p.get('appBase', default_appBase) %}
{% set path       = p.get('path', default_path) %}
{% set appName    = p.get('appName', default_appName) %}
{% set unpackWARs   = p.get('unpackWARs', default_unpackWARs) %}
{% set autoDeploy   = p.get('autoDeploy', default_autoDeploy) %}
{% set deployXML    = p.get('deployXML', default_deployXML) %}
{% set deployOnStartup = p.get('deployOnStartup', default_deployOnStartup) %}
{% set reloadable      = p.get('reloadable', default_reloadable) %}
{% set privileged      = p.get('privileged', default_privileged) %}
{% set debug           = p.get('debug', default_debug) %}


{% set tomcat = {} %}
{%- do tomcat.update({'home'    : home,
                      'name'    : name,
                      'package' : package,
                      'limitSoft': limitSoft,
                      'limitHard': limitHard,
                      'hostName'       : hostName,
                      'appBase'        : appBase,
                      'path'           : path,
                      'appName'        : appName,
                      'unpackWARs'     : unpackWARs,
                      'autoDeploy'     : autoDeploy,
                      'deployXML'      : deployXML,
                      'deployOnStartup' : deployOnStartup,
                      'reloadable'     : reloadable,
                      'privileged'     : privileged,
                      'debug'          : debug,
                      'versionPath'   : versionPath
                      }) %}


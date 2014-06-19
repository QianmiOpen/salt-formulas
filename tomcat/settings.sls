{% set p  = salt['pillar.get']('tomcat', {}) %}

{%- set default_tomcat_home = '/home/tomcat' %}
{%- set default_tomcat_base = 'tomcat' %}
{%- set default_package     = 'apache-tomcat-7.0.53.tar.gz' %}
{%- set default_version_path = 'apache-tomcat-7.0.53' %}
{%- set default_java_Xmx = '3G' %}
{%- set default_java_MaxPermSize = '256m' %}

{%- set default_hostName = 'localhost' %}
{%- set default_appBase  = '/home/tomcat/tomcat/webapps' %}
{%- set default_path     = '/' %}
{%- set default_appName  = 'server' %}
{%- set default_unpackWARs = 'false' %}
{%- set default_autoDeploy = 'false' %}
{%- set default_deployXML  = 'false' %}
{%- set default_deployOnStartup = 'false' %}
{%- set default_reloadable = 'false' %}
{%- set default_privileged = 'true' %}
{%- set default_debug = '0' %}


{%- set tomcat_home    = p.get('tomcat_home', default_tomcat_home) %}
{%- set tomcat_base    = p.get('tomcat_base', default_tomcat_base) %}
{%- set tomcat_package = p.get('tomcat_package', default_package) %}
{%- set version_path   = p.get('version_path', default_version_path) %}
{%- set java_Xmx       = p.get('java_Xmx', default_java_Xmx) %}
{%- set java_MaxPermSize = p.get('java_MaxPermSize', default_java_MaxPermSize) %}

{%- set hostName   = p.get('hostName', default_hostName) %}
{%- set appBase    = p.get('appBase', default_appBase) %}
{%- set path       = p.get('path', default_path) %}
{%- set appName    = p.get('appName', default_appName) %}
{%- set unpackWARs   = p.get('unpackWARs', default_unpackWARs) %}
{%- set autoDeploy   = p.get('autoDeploy', default_autoDeploy) %}
{%- set deployXML    = p.get('deployXML', default_deployXML) %}
{%- set deployOnStartup = p.get('deployOnStartup', default_deployOnStartup) %}
{%- set reloadable      = p.get('reloadable', default_reloadable) %}
{%- set privileged      = p.get('privileged', default_privileged) %}
{%- set debug           = p.get('debug', default_debug) %}


{%- set tomcat = {} %}
{%- do tomcat.update( { 'tomcat_home'    : tomcat_home,
                        'tomcat_base'    : tomcat_base,
                        'tomcat_package' : tomcat_package,
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
                        'version_path'   : version_path,
                        'java_Xmx'       : java_Xmx,
                        'java_MaxPermSize': java_MaxPermSize
                  }) %}


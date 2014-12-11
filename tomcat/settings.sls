{% set p  = salt['pillar.get']('tomcat', {}) %}
{% set g  = salt['grains.get']('tomcat', {}) %}

{% set tomcatConst = {} %}
{%- do tomcatConst.update({'packagePrefix'  : 'apache-tomcat-',
                           'packageSuffix'  : '.tar.gz',
                           }) %}

{% set tomcat = {} %}
{%- do tomcat.update({'home'           : '/home/tomcat',
                      'name'           : 'tomcat',

                      'version'        : '7.0.55',

                      'hostName'       : 'localhost',
                      'path'           : '',
                      'appName'        : 'server',
                      'unpackWARs'     : false,
                      'autoDeploy'     : false,
                      'deployXML'      : false,
                      'deployOnStartup': false,
                      'reloadable'     : false,
                      'privileged'     : true,
                      'maxThreads'     : 300,
                      'minSpareThreads': 10,
                      'connectionTimeout': 20000,
                      'stopDelaySeconds' : 60,
                      'logstashRedisHost' : '192.168.59.3',
                      'logstashRedisPort' : 6379,
                      'useLogback'      : true,
                      'gracefulOpen'    : true,
                      'forceInstall'    : false
                      }) %}

{% for key, value in tomcat.iteritems() %}
{% do tomcat.update({key: p.get(key, value)}) %}
{% endfor %}

{% if g.get('version', 'none') != tomcat.version %}
{% do tomcat.update({'forceInstall': true}) %}
{% endif%}

{% set package     = p.get('package', tomcatConst.packagePrefix + tomcat.version + tomcatConst.packageSuffix) %}
{% set versionPath = p.get('versionPath', tomcatConst.packagePrefix + tomcat.version) %}
{% set appBase     = p.get('appBase', tomcat.home + '/' + tomcat.name + '/webapps') %}
{% set tomcatPid   = p.get('tomcatPid', tomcat.home + '/tomcat.pid') %}
{% set CATALINA_BASE   = p.get('CATALINA_BASE', tomcat.home ~ '/' ~ tomcat.name) %}


{%- do tomcat.update({'package'        : package,
                      'appBase'        : appBase,
                      'versionPath'    : versionPath,
                      'tomcatPid'      : tomcatPid,
                      'CATALINA_BASE'  : CATALINA_BASE
                      }) %}

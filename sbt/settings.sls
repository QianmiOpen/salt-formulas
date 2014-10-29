{% set p= salt['pillar.get']('sbt',{}) %}

{% set sbt={} %}
{%- do sbt.update({'name'          : 'sbt',
                   'packagePrefix' : 'sbt-',
                   'version'       : '0.13.6',
                   'packageSuffix' : '.tgz',
                   'installPath'   : '/usr/share/sbt',
                   'sbtHome'       : '/usr/share/sbt/sbt/bin'
                 })%}
{% for key,value in sbt.iteritems() %}
{% do sbt.update({key:p.get(key,value)}) %}
{% endfor%}
{% set package     = p.get('package', sbt.packagePrefix + sbt.version + sbt.packageSuffix) %}
{%- do sbt.update({
                   'package' : package
                  })%}

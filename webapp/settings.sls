{% set w  = salt['pillar.get']('webapp', {}) %}

{%- set default_appName    = 'cardbase-release' %}
{%- set default_appVersion = '1.6.2-RELEASE' %}

{%- set appName    = w.get('appName', default_appName) %}
{%- set appVersion = w.get('appVersion', default_appVersion) %}

{%- set webapp = {} %}
{%- do webapp.update( { 'appName'    : appName,
                        'appVersion' : appVersion
                  }) %}

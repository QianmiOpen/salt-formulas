{% set p = salt['pillar.get']('webapp', {}) %}

{% set webapp = {} %}
{%- do webapp.update({'projectName': 'cardbase',
                      'nfsServer'  : '192.168.111.210',
                      'groupId'    : 'com.ofpay',
                      'artifactId' : 'cardserverimpl',
                      'version'    : '1.6.2-RELEASE',
                      'repoBase'   : 'nexus.dev.ofpay.com/nexus/service/local/artifact/maven/redirect?',
                      'repository' : 'releases',
                      'fileType'   : 'war',
                      'unzip'      : false
                      }) %}

{% for key, value in webapp.iteritems() %}
{% do webapp.update({key: p.get(key, value)}) %}
{% endfor %}

{% set fileUrl  = p.get('fileUrl', webapp.repoBase + 'r=' + webapp.repository + '&g=' + webapp.groupId + '&a=' + webapp.artifactId + '&v=' + webapp.version + '&e=' + webapp.fileType) %}
{% set fileSha1 = p.get('fileSha1', fileUrl + '.sha1') %}

{%- do webapp.update({'fileUrl'    : fileUrl,
                      'fileSha1'   : fileSha1
                      }) %}

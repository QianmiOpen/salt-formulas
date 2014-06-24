{% set p = salt['pillar.get']('webapp', {}) %}

{% set default_groupId    = 'com.ofpay' %}
{% set default_artifactId = 'cardserverimpl' %}
{% set default_version    = '1.6.2-RELEASE' %}
{% set default_repoBase   = 'nexus.dev.ofpay.com/nexus/content/repositories' %}
{% set default_repository = 'releases' %}
{% set default_fileType   = '.war' %}


{% set groupId    = p.get('groupId', default_groupId) %}
{% set artifactId = p.get('artifactId', default_artifactId) %}
{% set version    = p.get('version', default_version) %}
{% set repoBase   = p.get('repoBase', default_repoBase) %}
{% set repository = p.get('repository', default_repository) %}
{% set fileType   = p.get('fileType', default_fileType) %}


{% set fileUrl  = repoBase + '/' + repository + '/' + groupId|replace('.', '/') + '/' + artifactId + '/' + version + '/' + artifactId + '-' + version + fileType %}
{% set fileSha1 = p.get('fileSha1', fileUrl + '.sha1') %}

{% set webapp = {} %}
{%- do webapp.update({'groupId'    : groupId,
                      'artifactId' : artifactId,
                      'version'    : version,
                      'fileUrl'    : fileUrl,
                      'fileSha1'   : fileSha1
                      }) %}

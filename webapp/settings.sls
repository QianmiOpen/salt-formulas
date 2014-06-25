{% set p = salt['pillar.get']('webapp', {}) %}


{% set default_projectName = 'cardbase' %}
{% set default_nfsServer   = '192.168.111.210' %}
{% set default_groupId    = 'com.ofpay' %}
{% set default_artifactId = 'cardserverimpl' %}
{% set default_version    = '1.6.2-RELEASE' %}
{% set default_repoBase   = 'nexus.dev.ofpay.com/nexus/service/local/artifact/maven/redirect?' %}
{% set default_repository = 'releases' %}
{% set default_fileType   = 'war' %}

{% set projectName = p.get('projectName', default_projectName) %}
{% set nfsServer   = p.get('nfsServer', default_nfsServer) %}
{% set groupId    = p.get('groupId', default_groupId) %}
{% set artifactId = p.get('artifactId', default_artifactId) %}
{% set version    = p.get('version', default_version) %}
{% set repoBase   = p.get('repoBase', default_repoBase) %}
{% set repository = p.get('repository', default_repository) %}
{% set fileType   = p.get('fileType', default_fileType) %}


{% set fileUrl  = p.get('fileUrl', repoBase + 'r=' + repository + '&g=' + groupId + '&a=' + artifactId + '&v=' + version + '&e=' + fileType) %}
{% set fileSha1 = p.get('fileSha1', fileUrl + '.sha1') %}

{% set webapp = {} %}
{%- do webapp.update({'projectName': projectName,
                      'nfsServer'  : nfsServer,
                      'groupId'    : groupId,
                      'artifactId' : artifactId,
                      'version'    : version,
                      'fileUrl'    : fileUrl,
                      'fileSha1'   : fileSha1
                      }) %}

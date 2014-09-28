{%- from 'os/security/settings.sls' import security with context %}

# 2014-9-28 修复bash执行漏洞
bash:
  pkg.latest

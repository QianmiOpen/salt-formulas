{%- from 'auth/settings.sls' import auth with context %}
{%- from 'tomcat/settings.sls' import tomcat with context %}

{{tomcat.home}}/.ssh/authorized_keys:
  file.absent

{% if auth.users != None %}
{% if auth.users|length > 1 %}
{% for user in auth.users.split(',') %}
add-{{user|trim}}-ssh-key:
  ssh_auth.present:
    - user: tomcat
    - source: salt://auth/keys/{{user|trim}}
    - saltenv: base
{% endfor %}
{% endif %}
{% endif %}

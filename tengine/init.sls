{%- from 'tengine/settings.sls' import tengine with context %}

{% for package in [tengine.tengine, tengine.ssl, tengine.nginxSticky, tengine.nginxCache] %}
get-{{ package }}:
  file.managed:
    - name: {{ tengine.home }}/{{ package }}{{ tengine.zipType }}
    - source: salt://tengine/pkgs/{{ package }}{{ tengine.zipType }}
  cmd.run:
    - name: tar -zxf {{ tengine.home }}/{{ package }}{{ tengine.zipType }} -C {{ tengine.home }}
    - watch:
      - file: get-{{ package }}
{% endfor %}

configure-nginx:
  pkg.installed:
    - names:
      - pcre-devel
      - gcc
      - autoconf
      - automake
      - zlib-devel
      # - openssl-devel
  cmd.wait:
    - cwd: {{ tengine.home }}/{{ tengine.tengine }}
    - names:
      - ./configure --prefix=/tengine
        --with-http_ssl_module
        --with-http_stub_status_module
        --with-openssl={{ tengine.home }}/{{ tengine.ssl }}
        --with-http_upstream_check_module
        --with-http_concat_module
        --with-syslog
        --with-backtrace_module
        --with-http_realip_module
        --add-module={{ tengine.home }}/{{ tengine.nginxSticky }}
        --add-module={{ tengine.home }}/{{ tengine.nginxCache }}
        # --with-http_lua_module
    - watch:
      - cmd: get-{{ tengine.tengine }}
      - pkg: configure-nginx

compile-nginx:
  cmd.wait:
    - cwd: {{ tengine.home }}/{{ tengine.tengine }}
    - names:
      - make && make install
    - watch:
      - cmd: configure-nginx
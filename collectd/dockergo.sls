{% from "collectd/map.jinja" import collectd_settings with context %}

include:
  - collectd

collectd-docker-plugin:
  pkg.installed:
  - name: collectd-docker-plugin
  - require_in:
    - service: collectd-service
  - watch_in:
    - service: collectd-service


{{ collectd_settings.plugindirconfig }}/docker.conf:
  file.managed:
    - source: salt://collectd/files/dockergo.conf
    - user: {{ collectd_settings.user }}
    - group: {{ collectd_settings.group }}
    - mode: 644
    - template: jinja
    - watch_in:
      - service: collectd-service

/usr/share/collectd/docker.db:
  file.managed:
    - source: salt://collectd/files/dockergo.db
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: collectd-service

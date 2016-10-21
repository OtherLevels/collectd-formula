{% from "collectd/map.jinja" import collectd_settings with context %}

include:
  - collectd

docker-collectd-plugin:
  git.latest:
  - name: https://github.com/lebauce/docker-collectd-plugin
  - target: /usr/share/collectd/docker-collectd-plugin
  - require_in:
    - service: collectd-service
  - watch_in:
    - service: collectd-service


{{ collectd_settings.plugindirconfig }}/docker.conf:
  file.managed:
    - source: salt://collectd/files/docker.conf
    - user: {{ collectd_settings.user }}
    - group: {{ collectd_settings.group }}
    - mode: 644
    - template: jinja
    - watch_in:
      - service: collectd-service

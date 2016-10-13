{% from "collectd/map.jinja" import collectd_settings with context %}

include:
  - collectd

collectd-elasticsearch-module:
  git.latest:
  - name: https://github.com/OtherLevels/collectd-elasticsearch
  - rev: otherlevels
  - target: /usr/share/collectd/collectd-elasticsearch
  - require_in:
    - service: collectd-service
  - watch_in:
    - service: collectd-service


{{ collectd_settings.plugindirconfig }}/elasticsearch.conf:
  file.managed:
    - source: salt://collectd/files/elasticsearch.conf
    - user: {{ collectd_settings.user }}
    - group: {{ collectd_settings.group }}
    - mode: 644
    - template: jinja
    - watch_in:
      - service: collectd-service

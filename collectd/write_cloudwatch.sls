{% from "collectd/map.jinja" import collectd_settings with context %}

include:
  - collectd

pip-requests-module:
  pip.installed:
    - name: requests >= 2.12
    - require_in:
      - file: collect-cloudwatch-configure

collectd-cloudwatch-dir:
  file.directory:
    - names: 
      - /tmp/collectd-cloudwatch
    - user: root
    - group: root
    - mode: 0755

collectd-cloudwatch-download:
  cmd.run:
    - name: curl -sL https://github.com/awslabs/collectd-cloudwatch/tarball/master -o /tmp/collectd-cloudwatch.tar
    - creates: /tmp/collectd-cloudwatch.tar
    - unless: test -d /opt/collectd-plugins
    - require:
      - file: collectd-cloudwatch-dir

collectd-cloudwatch-extract:
  archive.extracted:
    - name: /tmp/collectd-cloudwatch
    - source: /tmp/collectd-cloudwatch.tar
    - user: root
    - group: root
    - archive_format: tar
    - options: --strip-components=1
    - enforce_toplevel: False
    - unless: test -d /opt/collectd-plugins
    - require:
      - cmd: collectd-cloudwatch-download

collect-cloudwatch-install:
  cmd.run:
    - name: mv /tmp/collectd-cloudwatch/src /opt/collectd-plugins
    - creates: /opt/collectd-plugins
    - require:
      - archive: collectd-cloudwatch-extract
    - require_in:
      - file: collect-cloudwatch-configure
    - unless: test -d /opt/collectd-plugins

collect-cloudwatch-configure:
  file.managed:
    - name: /opt/collectd-plugins/cloudwatch/config/plugin.conf
    - source: salt://collectd/files/cloudwatch_plugin.conf
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - watch_in:
      - service: collectd-service

{{ collectd_settings.plugindirconfig }}/write_cloudwatch.conf:
  file.managed:
    - source: salt://collectd/files/write_cloudwatch.conf
    - user: {{ collectd_settings.user }}
    - group: {{ collectd_settings.group }}
    - mode: 0644
    - template: jinja
    - watch_in:
      - service: collectd-service

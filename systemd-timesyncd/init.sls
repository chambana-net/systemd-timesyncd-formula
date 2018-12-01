# -*- coding: utf-8 -*-                                                                                                                                                                                           
# vim: ft=sls                                                                                                                                                                                                     
                                                                                                                                                                                                                  
{% from "systemd-timesyncd/map.jinja" import systemd-timesyncd with context %}                                                                                                                                                            
systemd_timesyncd_conf:
  file.managed:
    - name: /etc/systemd/timesyncd.conf
    - source: salt://systemd-timesyncd/files/timesyncd.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: systemd-timesyncd
    - context:
        timesyncd_config: {{ systemd-timesyncd }}

{% if salt['grains.get']('virtual') != 'physical' %}
systemd_timesyncd_virt:
  file.managed:
    - name: /etc/systemd/system/systemd-timesyncd.service.d/virt.conf
    - source: salt://systemd-timesyncd/files/virt.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
{% endif %}

systemd_timesyncd_service:
  service.running:
    - enable: true
    - require:
      - file: /etc/systemd/timesyncd.conf

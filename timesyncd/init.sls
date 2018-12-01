# -*- coding: utf-8 -*-                                                                                                                                                                                           
# vim: ft=sls                                                                                                                                                                                                     
                                                                                                                                                                                                                  
{% from "timesyncd/map.jinja" import timesyncd with context %}                                                                                                                                                            
timesyncd_conf:
  file.managed:
    - name: /etc/systemd/timesyncd.conf
    - source: salt://timesyncd/files/timesyncd.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: timesyncd_service
    - context:
        timesyncd_config: {{ timesyncd }}

{% if salt['grains.get']('virtual') != 'physical' %}
timesyncd_virt:
  file.managed:
    - name: /etc/systemd/system/systemd-timesyncd.service.d/virt.conf
    - source: salt://timesyncd/files/virt.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
{% endif %}

timesyncd_service:
  service.running:
    - name: systemd-timesyncd.service
    - enable: true
    - require:
      - file: /etc/systemd/timesyncd.conf

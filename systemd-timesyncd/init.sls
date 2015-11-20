/etc/systemd/timesyncd.conf:
  file.managed:
    - source: salt://systemd-timesyncd/config/timesyncd.conf.template
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: systemd-timesyncd

{% if salt['grains.get']('virtual') != 'physical' %}
/etc/systemd/system/systemd-timesyncd.service.d/virt.conf:
  file.managed:
    - source: salt://systemd-timesyncd/config/virt.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
{% endif %}

systemd-timesyncd:
  service.running:
    - enable: true
    - require:
      - file: /etc/systemd/timesyncd.conf

packages:
  pkg.installed:
    - pkgs:
      - yum-cron
      - mailx

{% if 0 == salt['cmd.retcode']('test -f /etc/yum/yum-cron.conf') %}
/etc/yum/yum-cron.conf:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://yum-cron/templates/yum-cron_conf.jinja
    - watch:
      - pkg: packages
{% endif %}

{% if 0 == salt['cmd.retcode']('test -f /etc/sysconfig/yum-cron') %}
/etc/sysconfig/yum-cron:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://yum-cron/templates/yum-cron.jinja
    - watch:
      - pkg: packages
{% endif %}

yum-cron:
  service:
    - running
    - enable: True
    - watch:
      - pkg: packages
      - file: /etc/yum/yum-cron.conf
      - file: /etc/sysconfig/yum-cron


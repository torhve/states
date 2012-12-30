clsuter-packages:
  pkg.installed:
    - pkgs:
      - corosync
      - clvm
      - pacemaker
      - cman
      - fence-agents

/etc/cluster/cluster.conf:
  file.managed:
    - source: salt://cluster/cluster.conf.jinja
    - template: jinja
    - mode: 444
    - require:
      - pkg: cman

/etc/corosync/corosync.conf:
  file.managed:
    - source: salt://cluster/corosync.conf.jinja
    - template: jinja
    - mode: 444
    - require:
      - pkg: corosync

/etc/init.d/clvm:
  file.managed:
    - user: root
    - group: root
    - mode: 555
    - source: salt://cluster/clvm
    - require:
      - pkg: clvm


cman:
  service.running:
    - enable: True
    - watch: 
      - file: /etc/corosync/corosync.conf
      - file: /etc/cluster/cluster.conf
      - file: /etc/init.d/clvm
    - require:
      - pkg: cman

clvm:
  service.running:
    - enable: True
    - require:
      - service: cman

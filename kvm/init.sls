kvm-packages:
  pkg.installed:
    - pkgs:
      - bridge-utils
      - libvirt-bin
      - virt-goodies
      - virt-manager
      - virt-top
      - virtinst
      - virt-viewer
      - vlan
      - guestfish
      - guestfsd
      - guestmount
      - lvm2
      - nfs-common
      - qemu-kvm
      - python-libvirt
      - munin-libvirt-plugins
      - munin-node
      - multipath-tools

/etc/libvirt/qemu.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 444
    - source: salt://kvm/qemu.conf
    - require:
      - pkg: kvm-packages

kvmhostkey:
  ssh_auth.present:
    - user: root
    - source: salt://ssh_keys/chani.id_rsa.pub

/root/.ssh/id_rsa:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - user: root
    - source: salt://kvm/id_rsa
        

libvirt-bin:
  service.running:
    - require:
      - pkg: kvm-packages
      - file: /etc/libvirt/qemu.conf
      - ssh_auth: kvmhostkey
    - watch: 
      - file: /etc/libvirt/qemu.conf

vm.swappiness:
  sysctl.present:
    - value: 0

vm.zone_reclaim_mode:
  sysctl.present:
    - value: 0

net.bridge.bridge-nf-call-arptables:
  sysctl.present:
    - value: 0
/hugepages:
  mount.mounted:
    - device: hugetlbfs
    - fstype: hugetlbfs
    - mkmnt: True
/mnt/balin/iso:
  mount.mounted:
    - device: 10.2.10.10:/mnt/balin/iso
    - fstype: nfs
    - mkmnt: True
    - opts:
      - vers=3
      - async
      - tcp
      - hard
      - intr
      - rsize=32768
      - wsize=32768
      - auto
      - noatime
/mnt/vmsysstorage:
  mount.mounted:
    - device: 10.2.10.10:/mnt/vmsysstorage
    - fstype: nfs
    - mkmnt: True
    - opts:
      - vers=3
      - async
      - tcp
      - hard
      - intr
      - rsize=32768
      - wsize=32768
      - auto
      - noatime
/mnt/vmdatastorage:
  mount.mounted:
    - device: 10.2.10.10:/mnt/vmdatastorage
    - fstype: nfs
    - mkmnt: True
    - opts:
      - vers=3
      - async
      - tcp
      - hard
      - intr
      - rsize=32768
      - wsize=32768
      - auto
      - noatime

/vm:
  mount.mounted:
    - device: 10.2.10.50:/vm
    - fstype: nfs
    - mkmnt: True
    - opts:
      - vers=3
      - async
      - tcp
      - hard
      - intr
      - rsize=32768
      - wsize=32768
      - auto
      - noatime

grub-settings:
  file.append:
    - name: /etc/default/grub
    - text: 'GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0,9600n8 console=tty0 text nosplash nomodeset nohz=off transparent_hugepage=always"'
grub-settings2:
  file.append:
    - name: /etc/default/grub
    - text: 'GRUB_CMDLINE_LINUX="console=ttyS0,9600n8 console=tty0 text nosplash nomodeset nohz=off transparent_hugepage=always"'

update-grub:
  cmd.run:
    - name: update-grub
    - require:
      - file.append: grub-settings
      - file.append: grub-settings2

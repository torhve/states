vim:
  pkg:
    {% if grains['os_family'] == 'RedHat' %}
    - name: vim-enhanced
    {% elif grains['os'] == 'Debian' %}
    - name: vim-nox
    {% elif grains['os'] == 'Ubuntu' %}
    - name: vim-nox
    {% endif %}
    - installed

/etc/vim/vimrc:
  file:
    - managed
    - source: salt://vim/vimrc
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - makedirs: True
    - require:
      - pkg: vim


/usr/share/vim/vimfiles/ftdetect/sls.vim:
  file:
    - managed
    - source: salt://vim/salt-vim/ftdetect/sls.vim
    - user: root
    - group: root
    - mode: 444
    - makedirs: True
    - require:
      - pkg: vim
/usr/share/vim/vimfiles/syntax/sls.vim:
  file:
    - managed
    - source: salt://vim/salt-vim/syntax/sls.vim
    - user: root
    - group: root
    - mode: 444
    - makedirs: True
    - require:
      - pkg: vim

/usr/share/vim/vimfiles/ftplugin/sls.vim:
  file:
    - managed
    - source: salt://vim/salt-vim/ftplugin/sls.vim
    - user: root
    - group: root
    - mode: 444
    - makedirs: True
    - require:
      - pkg: vim


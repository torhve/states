python-numpy:
  pkg.installed

/usr/local/bin/websockify:
  file.managed:                                  
    - source: salt://wsproxy/websockify
    - mode: 555
    - require: 
      - pkg: python-numpy

/usr/local/bin/websocket.py:
  file.managed:                                  
    - source: salt://wsproxy/websocket.py
    - mode: 444
    - require: 
      - pkg: python-numpy

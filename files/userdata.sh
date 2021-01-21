 #! /bin/bash
 sudo apt  update
 sudo apt install python
 curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
 python get-pip.py --user
 python -m pip install --user ansible

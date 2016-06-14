""" scrumtious/helpers.py
"""
import os

from coffeescript import compile_file

def csCompile(sourcename, targetname):
    targetpath = os.path.abspath(targetname)
    if not os.path.exists(targetpath):
        os.mkdir(targetpath)

    sourcepath = os.path.abspath(sourcename)
    for itemname in os.listdir(sourcepath):
        itempath = os.path.join(sourcepath, itemname)
        if os.path.isdir(itempath):
            csCompile(itempath, os.path.join(targetpath, itemname))
        else:
            jsname = itemname.split('.')[0] + '.js'
            open(os.path.join(targetpath, jsname), 'w').write(compile_file(itempath, bare=True))

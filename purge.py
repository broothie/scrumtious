""" purge.py
"""
from os import environ

from pyflare import PyflareClient, APIError

try:
    cf = PyflareClient(environ['CLOUDFLARE_EMAIL'], environ['CLOUDFLARE_KEY'])
    cf.fpurge_ts('scrumtio.us')
except KeyError:
    exit()
except APIError as error:
    print 'Purge failed'
    print error

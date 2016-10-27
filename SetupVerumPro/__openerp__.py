# -*- coding: utf-8 -*-
{
    'name': 'Setup VerumPro',
    'version': '1.0',
    'category': '',
    "sequence": 14,
    'complexity': "easy",
    'category': 'Hidden',
    'description': """
        This module will setup VerumPro on your server.
    """,
    'author': 'Target Integration Ltd',
    'website': 'www.targetintegration.com',
    'depends': ["mail",'web'],
    'init_xml': [],
    'data': [
        "base_view.xml",
        "mail_data.xml",
    ],
    'demo_xml': [],
    'test': [
    ],
    'qweb' : [
        "static/src/xml/base.xml",
    ],
    'installable': True,
    'auto_install': True,
}
# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:

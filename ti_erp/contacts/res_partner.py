# -*- coding: utf-8 -*-
##############################################################################
#
#    OpenERP, Open Source Management Solution
#    Copyright (C) 2004-2010 Tiny SPRL (<http://tiny.be>).
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

from openerp.osv import osv, fields

class res_partner(osv.osv):
    _inherit='res.partner'
    _columns={
              'salutation':fields.char('Salutation',size=10),
              'lead_source':fields.char('Lead Source',size=50),
              'home_phone':fields.char('Home Phone',size=50),
              'other_phone':fields.char('Other Phone',size=50),
              'do_not_call': fields.boolean('Do Not Call'),
              'birthday':fields.char('Birthday',size=100),
              'industry':fields.char('Industry',size=25),
              'type':fields.char('Type',size=20)
              }

# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:
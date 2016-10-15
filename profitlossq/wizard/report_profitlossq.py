# -*- coding: utf-8 -*-

from openerp.osv import fields, osv


class profitlossq_report(osv.osv_memory):
    _inherit = "account.common.account.report"
    _name = 'profitlossq.report'
    _description = 'Profit Loss Qweb'

    _columns = {
        'journal_ids': fields.many2many('account.journal', 'account_balance_report_journal_rel', 'account_id', 'journal_id', 'Journals', required=True),
    }

    _defaults = {
        'journal_ids': [],
    }

    def _print_report(self, cr, uid, ids, data, context=None):
        data = self.pre_print_report(cr, uid, ids, data, context=context)
        return self.pool['report'].get_action(cr, uid, [], 'profitlossq.report_profitlossq', data=data, context=context)

# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:

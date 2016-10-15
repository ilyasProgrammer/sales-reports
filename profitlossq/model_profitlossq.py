# -*- coding: utf-8 -*-

import time
import math

from openerp.osv import osv
from openerp.report import report_sxw
from common_report_header import common_report_header


class profitlossq(report_sxw.rml_parse, common_report_header):
    _name = 'profitlossq'

    def __init__(self, cr, uid, name, context=None):
        super(profitlossq, self).__init__(cr, uid, name, context=context)
        self.sum_debit = 0.00
        self.sum_credit = 0.00
        self.date_lst = []
        self.date_lst_string = ''
        self.result_acc = []
        self.localcontext.update({
            'time': time,
            'lines': self.lines,
            'sum_debit': self._sum_debit,
            'sum_credit': self._sum_credit,
            'get_fiscalyear':self._get_fiscalyear,
            'get_filter': self._get_filter,
            'get_start_period': self.get_start_period,
            'get_end_period': self.get_end_period ,
            'get_account': self._get_account,
            'get_lines': self.get_lines,
            'get_journal': self._get_journal,
            'get_start_date':self._get_start_date,
            'get_end_date':self._get_end_date,
            'get_target_move': self._get_target_move,
        })
        self.context = context

    def set_context(self, objects, data, ids, report_type=None):
        new_ids = ids
        if (data['model'] == 'ir.ui.menu'):
            new_ids = 'chart_account_id' in data['form'] and [data['form']['chart_account_id']] or []
            objects = self.pool.get('account.account').browse(self.cr, self.uid, new_ids)
        return super(profitlossq, self).set_context(objects, data, new_ids, report_type=report_type)

    def lines(self, form, ids=None, done=None):
        def _process_child(accounts, disp_acc, parent):
                account_rec = [acct for acct in accounts if acct['id']==parent][0]
                currency_obj = self.pool.get('res.currency')
                acc_id = self.pool.get('account.account').browse(self.cr, self.uid, account_rec['id'])
                currency = acc_id.currency_id and acc_id.currency_id or acc_id.company_id.currency_id
                res = {
                    'id': account_rec['id'],
                    'type': account_rec['type'],
                    'code': account_rec['code'],
                    'name': account_rec['name'],
                    'level': account_rec['level'],
                    'debit': account_rec['debit'],
                    'credit': account_rec['credit'],
                    'balance': account_rec['balance'],
                    'parent_id': account_rec['parent_id'],
                    'bal_type': '',
                }
                self.sum_debit += account_rec['debit']
                self.sum_credit += account_rec['credit']
                if disp_acc == 'movement':
                    if not currency_obj.is_zero(self.cr, self.uid, currency, res['credit']) or not currency_obj.is_zero(self.cr, self.uid, currency, res['debit']) or not currency_obj.is_zero(self.cr, self.uid, currency, res['balance']):
                        self.result_acc.append(res)
                elif disp_acc == 'not_zero':
                    if not currency_obj.is_zero(self.cr, self.uid, currency, res['balance']):
                        self.result_acc.append(res)
                else:
                    self.result_acc.append(res)
                if account_rec['child_id']:
                    for child in account_rec['child_id']:
                        _process_child(accounts,disp_acc,child)

        obj_account = self.pool.get('account.account')
        if not ids:
            ids = self.ids
        if not ids:
            return []
        if not done:
            done={}

        ctx = self.context.copy()

        ctx['fiscalyear'] = form['fiscalyear_id']
        if form['filter'] == 'filter_period':
            ctx['period_from'] = form['period_from']
            ctx['period_to'] = form['period_to']
        elif form['filter'] == 'filter_date':
            ctx['date_from'] = form['date_from']
            ctx['date_to'] = form['date_to']
        ctx['state'] = form['target_move']
        parents = ids
        child_ids = obj_account._get_children_and_consol(self.cr, self.uid, ids, ctx)
        if child_ids:
            ids = child_ids
        accounts = obj_account.read(self.cr, self.uid, ids, ['type','code','name','debit','credit','balance','parent_id','level','child_id'], ctx)

        for parent in parents:
                if parent in done:
                    continue
                done[parent] = 1
                _process_child(accounts,form['display_account'],parent)
        return self.result_acc

    def get_lines(self, data):
        lines = []
        exp_ids = self.pool.get('account.account').search(self.cr, self.uid, [('user_type','=','Expense')])
        inc_ids = self.pool.get('account.account').search(self.cr, self.uid, [('user_type','=','Income')])
        year = int(self._get_fiscalyear(data))
        # oexp = self.pool.get('account.account').browse(self.cr, self.uid, exp_ids)
        # oinc = self.pool.get('account.account').search(self.cr, self.uid, inc_ids)

        # Income
        self.cr.execute("""
                            SELECT round(date_part('month',m.date))::integer as month, sum(m.debit) as debit, sum(m.credit) as credit
                            FROM account_move_line as m
                            WHERE m.account_id IN %s
                            AND round(date_part('year',m.date))::integer = %s
                            GROUP BY month
                        """, (tuple(inc_ids), year))

        inc_total = self.cr.dictfetchall()
        vals = {}
        for r in inc_total:
            vals[r['month']] = math.fabs(r['debit'] - r['credit'])
        vals['account'] = 'Income'
        vals['level'] = 1
        lines.append(vals)
        self.cr.execute("""
                            SELECT a.name as account
                            FROM account_move_line as m
                            LEFT JOIN account_account as a
                            ON m.account_id = a.id
                            WHERE m.account_id IN %s
                            AND round(date_part('year',m.date))::integer = %s
                            GROUP BY account
                        """, (tuple(inc_ids), year))
        inc_names = self.cr.dictfetchall()
        for name in inc_names:
            self.cr.execute("""
                                SELECT round(date_part('month',m.date))::integer as month, a.name as account, sum(m.debit) as debit, sum(m.credit) as credit
                                FROM account_move_line as m
                                LEFT JOIN account_account as a
                                ON m.account_id = a.id
                                WHERE a.name = %s
                                AND round(date_part('year',m.date))::integer = %s
                                GROUP BY month, account
                            """, (name['account'], year))
            inc = self.cr.dictfetchall()
            vals = {}
            for x in inc:
                vals[x['month']] = math.fabs(x['debit'] - x['credit'])
            vals['account'] = name['account']
            vals['level'] = 4
            lines.append(vals)

        # Expense
        self.cr.execute("""
                            SELECT round(date_part('month',m.date))::integer as month, sum(m.debit) as debit, sum(m.credit) as credit
                            FROM account_move_line as m
                            WHERE m.account_id IN %s
                            AND round(date_part('year',m.date))::integer = %s
                            GROUP BY month
                        """, (tuple(exp_ids), year))
        exp_total = self.cr.dictfetchall()
        vals = {}
        for r in exp_total:
            vals[r['month']] = math.fabs(r['debit'] - r['credit'])
        vals['account'] = 'Expense'
        vals['level'] = 1
        lines.append(vals)
        self.cr.execute("""
                            SELECT a.name as account
                            FROM account_move_line as m
                            LEFT JOIN account_account as a
                            ON m.account_id = a.id
                            WHERE m.account_id IN %s
                            AND round(date_part('year',m.date))::integer = %s
                            GROUP BY account
                        """, (tuple(exp_ids), year))
        exp_names = self.cr.dictfetchall()
        for name in exp_names:
            self.cr.execute("""
                                SELECT round(date_part('month',m.date))::integer as month, a.name as account, sum(m.debit) as debit, sum(m.credit) as credit
                                FROM account_move_line as m
                                LEFT JOIN account_account as a
                                ON m.account_id = a.id
                                WHERE a.name = %s
                                AND round(date_part('year',m.date))::integer = %s
                                GROUP BY month, account
                            """, (name['account'], year))
            inc = self.cr.dictfetchall()
            vals = {}
            for x in inc:
                vals[x['month']] = math.fabs(x['debit'] - x['credit'])
            vals['account'] = name['account']
            vals['level'] = 4
            lines.append(vals)

        return lines


class report_trialbalance(osv.AbstractModel):
    _name = 'report.profitlossq.report_profitlossq'
    _inherit = 'report.abstract_report'
    _template = 'profitlossq.report_profitlossq'
    _wrapped_report_class = profitlossq


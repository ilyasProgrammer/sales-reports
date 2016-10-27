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
            data['form']['landscape'] = True
        return super(profitlossq, self).set_context(objects, data, new_ids, report_type=report_type)

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
        total_sum = 0
        vals = {}
        for r in inc_total:
            vals[r['month']] = math.fabs(r['debit'] - r['credit'])
            total_sum += vals[r['month']]
        vals['account'] = 'Income'
        vals['total'] = total_sum
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
            total_sum = 0
            for x in inc:
                vals[x['month']] = math.fabs(x['debit'] - x['credit'])
                total_sum += vals[x['month']]
            vals['account'] = name['account']
            vals['total'] = total_sum
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
        total_sum = 0
        for r in exp_total:
            vals[r['month']] = math.fabs(r['debit'] - r['credit'])
            total_sum += vals[r['month']]
        vals['account'] = 'Expense'
        vals['total'] = total_sum
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
            total_sum = 0
            for x in inc:
                vals[x['month']] = math.fabs(x['debit'] - x['credit'])
                total_sum += vals[x['month']]
            vals['account'] = name['account']
            vals['total'] = total_sum
            vals['level'] = 4
            lines.append(vals)

        return lines


class report_trialbalance(osv.AbstractModel):
    _name = 'report.profitlossq.report_profitlossq'
    _inherit = 'report.abstract_report'
    _template = 'profitlossq.report_profitlossq'
    _wrapped_report_class = profitlossq

# -*- coding: utf-8 -*-

from odoo import fields, models


class BusinessData(models.Model):
    _name = "data.order"
    _description = "Business Data"

    business_name = fields.Char()
    telephone = fields.Char()
    address = fields.Char()
    state = fields.Char()
    post_code = fields.Char()
    manta_url = fields.Char()
    source_url = fields.Char()
    comment = fields.Char()
    catagery = fields.Char()

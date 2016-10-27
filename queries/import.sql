CREATE EXTENSION dblink;

--------rp from IE-------
INSERT INTO res_partner (id, active, barcode, city, color, comment, commercial_company_name, commercial_partner_id, company_id, company_name, country_id, create_date, create_uid, credit_limit, customer, date, debit_limit, display_name, email, employee, fax, function, invoice_warn_msg, invoice_warn, is_company, lang, last_time_entries_checked, message_bounce, message_last_post, mobile, name, notify_email, opt_out, parent_id, partner_share, phone, ref, sale_warn_msg, sale_warn, signup_expiration, signup_token, signup_type, state_id, street, street2, supplier, team_id, title, type, tz, user_id, vat, website, write_date, write_uid, zip) 
SELECT                   id, active, '' AS barcode, city, color, comment, name as commercial_company_name, NULL AS commercial_partner_id, company_id, name AS company_name, 1 AS country_id, create_date, 1 AS create_uid, credit_limit, customer, date, debit_limit, display_name, email, employee, fax, function, '' AS invoice_warn_msg, '' AS invoice_warn, is_company, lang, NULL AS last_time_entries_checked, NULL AS message_bounce, NULL AS message_last_post, mobile, name, '' AS notify_email, opt_out, NULL AS parent_id, NULL AS partner_share, phone, ref, NULL AS sale_warn_msg, TRUE AS sale_warn, signup_expiration, signup_token, signup_type, state_id, street, street2, supplier, NULL AS team_id, NULL AS title, type, tz, NULL AS user_id, vat, website, write_date, 1 AS write_uid, zip 
FROM rp 
WHERE id NOT IN (SELECT id FROM res_partner) 
ORDER BY id DESC;

UPDATE res_partner SET parent_id = (SELECT parent_id FROM rp WHERE parent_id IS NOT NULL AND rp.id = res_partner.id);

--------rp2 from ti2---------
INSERT INTO res_partner (id, active, barcode, city, color, comment, commercial_company_name, commercial_partner_id, company_id, company_name, country_id, create_date, create_uid, credit_limit, customer, date, debit_limit, display_name, email, employee, fax, function, invoice_warn_msg, invoice_warn, is_company, lang, last_time_entries_checked, message_bounce, message_last_post, mobile, name, notify_email, opt_out, parent_id, partner_share, phone, ref, sale_warn_msg, sale_warn, signup_expiration, signup_token, signup_type, state_id, street, street2, supplier, team_id, title, type, tz, user_id, vat, website, write_date, write_uid, zip) 
SELECT                   id, active, '' AS barcode, city, color, comment, name as commercial_company_name, NULL AS commercial_partner_id, company_id, name AS company_name, 1 AS country_id, create_date, 1 AS create_uid, credit_limit, customer, date, debit_limit, display_name, email, employee, fax, function, '' AS invoice_warn_msg, '' AS invoice_warn, is_company, lang, NULL AS last_time_entries_checked, NULL AS message_bounce, NULL AS message_last_post, mobile, name, '' AS notify_email, opt_out, NULL AS parent_id, NULL AS partner_share, phone, ref, NULL AS sale_warn_msg, TRUE AS sale_warn, signup_expiration, signup_token, signup_type, state_id, street, street2, supplier, NULL AS team_id, NULL AS title, type, tz, NULL AS user_id, vat, website, write_date, 1 AS write_uid, zip 
FROM rp2 
WHERE id NOT IN (SELECT id FROM res_partner ORDER BY id DESC)
ORDER BY id DESC;

UPDATE res_partner SET city = rp2.city, color = rp2.color, comment = rp2.comment, company_id = rp2.company_id, credit_limit = rp2.credit_limit, customer = rp2.customer, date = rp2.date, debit_limit = rp2.debit_limit, display_name = rp2.display_name, email = rp2.email, employee = rp2.employee, fax = rp2.fax, function = rp2.function, is_company = rp2.is_company, lang = rp2.lang, mobile = rp2.mobile, name = rp2.name, opt_out = rp2.opt_out, phone = rp2.phone, ref = rp2.ref, signup_expiration = rp2.signup_expiration, signup_token = rp2.signup_token, signup_type = rp2.signup_type, state_id = rp2.state_id, street = rp2.street, street2 = rp2.street2, supplier = rp2.supplier, type = rp2.type, tz = rp2.tz, vat = rp2.vat, website = rp2.website, zip = rp2.zip 
FROM rp2 WHERE rp2.id = res_partner.id;
     
UPDATE res_partner SET parent_id = (SELECT parent_id FROM rp2 WHERE parent_id IS NOT NULL AND rp2.id = res_partner.id);

-------------mail_alias from ti2------------------
INSERT INTO mail_alias (id, create_uid, create_date, alias_defaults, alias_contact, alias_parent_model_id, write_uid, alias_force_thread_id, alias_model_id, write_date, alias_parent_thread_id, alias_user_id, alias_name)  
SELECT                  id, create_uid, create_date, alias_defaults, '' AS alias_contact, NULL AS alias_parent_model_id, write_uid, alias_force_thread_id, alias_model_id, write_date, NULL AS alias_parent_thread_id, alias_user_id, alias_name 
FROM ma 
WHERE id NOT IN (SELECT id FROM mail_alias) AND alias_model_id in (SELECT id FROM ir_model);

-------------res_users from ti2------------------
INSERT INTO res_users (id, active, login, password, company_id, partner_id, create_date, share, write_uid, create_uid, action_id, write_date, signature, password_crypt, alias_id, sale_team_id)  
SELECT                 id, active, login, password, company_id, partner_id, create_date, share, write_uid, create_uid, action_id, write_date, signature, '' AS password_crypt, alias_id, 1 AS sale_team_id 
FROM ru WHERE id NOT IN (SELECT id FROM res_users);

--------mail_message from ti2------------------------
INSERT INTO mail_message (id, create_date, write_date, mail_server_id, write_uid, subject, create_uid, parent_id, subtype_id, res_id, message_id, body, record_name, no_auto_thread, date, reply_to, author_id, model, message_type, email_from) 
SELECT                    id, create_date, write_date, 1 as mail_server_id, 1 as write_uid, subject, 1 as create_uid, parent_id, NULL AS subtype_id, res_id, message_id, body, record_name, TRUE as no_auto_thread, date, '' as reply_to, author_id, model, type as message_type, email_from 
FROM mm 
WHERE id NOT IN (SELECT id FROM mail_message)

------res_partner_title from ti2----------------
INSERT INTO res_partner_title (id, create_uid, create_date, name, shortcut, write_uid, write_date)
SELECT DISTINCT ON (name) id, 1 AS create_uid, create_date, name, shortcut, 1 AS write_uid, write_date 
FROM rpt 
WHERE (rpt.name NOT IN (SELECT name FROM res_partner_title)) AND (rpt.id NOT IN (SELECT id FROM res_partner_title)) 

------crm_stage from ti2 crm_case_stage -----------
INSERT INTO crm_stage (id, create_date, create_uid, fold, legend_priority, name, on_change, probability, requirements, sequence, write_date, write_uid)  
SELECT id, create_date, create_uid, fold, NULL AS legend_priority, name, on_change, probability, requirements, sequence, write_date, write_uid 
FROM ccs WHERE id not in (SELECT id FROM crm_stage)

-------LEADs from ti2----------------
INSERT INTO crm_lead (id, active, campaign_id, city, color, company_id, contact_name, country_id, create_date, create_uid, date_action_last, date_action_next, date_action, date_closed, date_conversion, date_deadline, date_last_stage_update, date_open, day_close, day_open, description, email_cc, email_from, fax, function, lost_reason, medium_id, message_bounce, message_last_post, mobile, name, next_activity_id, opt_out, partner_id, partner_name, phone, planned_revenue, priority, probability, referred, source_id, stage_id, state_id, street, street2, team_id, title_action, title, type, user_id, write_date, write_uid, zip)  
SELECT 	              id, active, campaign_id, city, color, company_id, contact_name, country_id, create_date, 1 AS create_uid, date_action_last, date_action_next, date_action, date_closed, NULL AS date_conversion, date_deadline, date_last_stage_update, date_open, day_close, day_open, description, email_cc, email_from, fax, function, NULL AS lost_reason, medium_id, message_bounce, message_last_post, mobile, name, NULL AS next_activity_id, opt_out, partner_id, partner_name, phone, planned_revenue, priority, probability, referred, source_id, stage_id, state_id, street, street2, NULL AS team_id, title_action, 1 AS title, type, 1 AS user_id, write_date, 1 AS write_uid, zip 
FROM cl 
WHERE cl.company_id = 1 AND partner_id in (SELECT id FROM res_partner)

-------update mail_message------
UPDATE mail_message SET model = mm.model
FROM mm WHERE mm.id = mail_message.id;

-------mail_followers from ti2----------------
INSERT INTO mail_followers (id, res_model, res_id, partner_id)  
SELECT                      id, res_model, res_id, partner_id
FROM mf 
WHERE id NOT IN (SELECT id FROM mail_followers) AND (res_model, res_id, partner_id) NOT IN (SELECT res_model, res_id, partner_id FROM mail_followers)
     
-------mail_message_subtype from ti2----------------
INSERT INTO mail_message_subtype (id, create_date, create_uid, "default", description, hidden, internal, name, parent_id, relation_field, res_model, sequence, write_date, write_uid)  
SELECT                      	  id, create_date, create_uid, "default", description, hidden, NULL,     name, parent_id, relation_field, res_model, sequence, write_date, write_uid
FROM mms 
WHERE id NOT IN (SELECT id FROM mail_message_subtype)

-------mail_followers_mail_message_subtype_rel from ti2----------------
INSERT INTO mfmmsr(mail_followers_id,mail_message_subtype_id)
SELECT 		   mail_followers_id,mail_message_subtype_id
FROM mfmmsr 

-------update mail_message------
UPDATE mail_message SET subtype_id = mm.subtype_id, message_type = mm.type
FROM mm WHERE mm.id = mail_message.id AND mm.subtype_id IN (SELECT id FROM mail_message_subtype);

-------crm_phonecall from ti2----------------
INSERT INTO crm_phonecall (id, active, campaign_id, city, color, company_id, contact_name, country_id, create_date, create_uid, date_action_last, date_action_next, date_action, date_closed, date_conversion, date_deadline, date_last_stage_update, date_open, day_close, day_open, description, email_cc, email_from, fax, function, lost_reason, medium_id, message_bounce, message_last_post, mobile, name, next_activity_id, opt_out, partner_id, partner_name, phone, planned_revenue, priority, probability, referred, source_id, stage_id, state_id, street, street2, team_id, title_action, title, type, user_id, write_date, write_uid, zip)  
SELECT 	              id, active, campaign_id, city, color, company_id, contact_name, country_id, create_date, 1 AS create_uid, date_action_last, date_action_next, date_action, date_closed, NULL AS date_conversion, date_deadline, date_last_stage_update, date_open, day_close, day_open, description, email_cc, email_from, fax, function, NULL AS lost_reason, medium_id, message_bounce, message_last_post, mobile, name, NULL AS next_activity_id, opt_out, partner_id, partner_name, phone, planned_revenue, priority, probability, referred, source_id, stage_id, state_id, street, street2, NULL AS team_id, title_action, 1 AS title, type, 1 AS user_id, write_date, 1 AS write_uid, zip 
FROM cp

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_followers_mail_message_subtype_rel';



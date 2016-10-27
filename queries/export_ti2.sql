CREATE TABLE rp2(LIKE res_partner);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'res_partner';
  
INSERT INTO rp2 (id, active, birthdate, birthday, calendar_last_notif_ack, city, color, comment, commercial_partner_id, company_id, country_id, create_date, create_uid, credit_limit, customer, date, debit_limit, display_name, do_not_call, ean13, email, employee, fax, function, home_phone, image_medium, image_small, image, industry, is_company, lang, last_reconciliation_date, lead_source, linkedin_id, linkedin_url, message_last_post, mobile, name, notify_email, opt_out, other_phone, parent_id, phone, ref, salutation, section_id, signup_expiration, signup_token, signup_type, state_id, street, street2, supplier, title, type, tz, use_parent_address, user_id, vat_subjected, vat, website, write_date, write_uid, zip) 
SELECT id, active, birthdate, birthday, calendar_last_notif_ack, city, color, comment, commercial_partner_id, company_id, country_id, create_date, create_uid, credit_limit, customer, date, debit_limit, display_name, do_not_call, ean13, email, employee, fax, function, home_phone, image_medium, image_small, image, industry, is_company, lang, last_reconciliation_date, lead_source, linkedin_id, linkedin_url, message_last_post, mobile, name, notify_email, opt_out, other_phone, parent_id, phone, ref, salutation, section_id, signup_expiration, signup_token, signup_type, state_id, street, street2, supplier, title, type, tz, use_parent_address, user_id, vat_subjected, vat, website, write_date, write_uid, zip 
FROM res_partner
ORDER BY id;

-----res_partner_title----------------
CREATE TABLE rpt(LIKE res_partner_title);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'res_partner_title';
  
INSERT INTO rpt (id,
create_uid,
domain,
create_date,
name,
shortcut,
write_uid,
write_date)
SELECT id,
create_uid,
domain,
create_date,
name,
shortcut,
write_uid,
write_date
FROM res_partner_title

-----crm_case_stage----------------

CREATE TABLE ccs(LIKE crm_case_stage);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'crm_case_stage';
  
INSERT INTO ccs (id,
case_default,
create_date,
create_uid,
fold,
name,
on_change,
probability,
requirements,
sequence,
type,
write_date,
write_uid)
SELECT id,
case_default,
create_date,
create_uid,
fold,
name,
on_change,
probability,
requirements,
sequence,
type,
write_date,
write_uid
FROM crm_case_stage


-----LEAD----------------
CREATE TABLE cl(LIKE crm_lead);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'crm_lead';
  
INSERT INTO cl (id, active, annual_revenue, campaign_id, city, color, company_id, contact_name, country_id, create_date, create_uid, date_action_last, date_action_next, date_action, date_closed, date_deadline, date_last_stage_update, date_open, day_close, day_open, description, email_cc, email_from, fax, function, lead_source, medium_id, message_bounce, message_last_post, mobile, name, opt_out, partner_id, partner_name, payment_mode, phone, planned_cost, planned_revenue, priority, probability, ref, ref2, referred, section_id, source_id, stage_id, state_id, street, street2, subscribe_news, title_action, title, type, user_id, website, write_date, write_uid, zip) 
SELECT id, active, annual_revenue, campaign_id, city, color, company_id, contact_name, country_id, create_date, create_uid, date_action_last, date_action_next, date_action, date_closed, date_deadline, date_last_stage_update, date_open, day_close, day_open, description, email_cc, email_from, fax, function, lead_source, medium_id, message_bounce, message_last_post, mobile, name, opt_out, partner_id, partner_name, payment_mode, phone, planned_cost, planned_revenue, priority, probability, ref, ref2, referred, section_id, source_id, stage_id, state_id, street, street2, subscribe_news, title_action, title, type, user_id, website, write_date, write_uid, zip 
FROM crm_lead

-----mail_followers---------------
CREATE TABLE mf(LIKE mail_followers);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_followers';
  
INSERT INTO mf(id, res_model, res_id, partner_id)
SELECT id, res_model, res_id, partner_id
FROM mail_followers


-----mail_message_subtype---------------
CREATE TABLE mms(LIKE mail_message_subtype);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_message_subtype';
  
INSERT INTO mms(id, create_date, create_uid, "default", description, hidden, name, parent_id, relation_field, res_model, sequence, write_date, write_uid)
SELECT 		id, create_date, create_uid, "default", description, hidden, name, parent_id, relation_field, res_model, sequence, write_date, write_uid
FROM mail_message_subtype

-----mail_followers_mail_message_subtype_rel---------------
CREATE TABLE mfmmsr(LIKE mail_followers_mail_message_subtype_rel);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_followers_mail_message_subtype_rel';
  
INSERT INTO mfmmsr(mail_followers_id,mail_message_subtype_id)
SELECT 		   mail_followers_id,mail_message_subtype_id
FROM mail_followers_mail_message_subtype_rel

---------------mail_message--------------------
CREATE TABLE mm (LIKE mail_message);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_message';

INSERT INTO mm (id, author_id, body, create_date, create_uid, date, email_from, mail_server_id, message_id, model, no_auto_thread, parent_id, record_name, reply_to, res_id, subject, subtype_id, type, write_date, write_uid)
SELECT          id, author_id, body, create_date, create_uid, date, email_from, mail_server_id, message_id, model, no_auto_thread, parent_id, record_name, reply_to, res_id, subject, subtype_id, type, write_date, write_uid
FROM mail_message; 


-----calls from ti2----------------
CREATE TABLE cp(LIKE crm_phonecall);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'crm_phonecall';
  
INSERT INTO cp (id, active, categ_id, company_id, create_date, create_uid, date_action_last, date_action_next, date_closed, date_open, date, description, duration, email_from, message_last_post, name, opportunity_id, partner_id, partner_mobile, partner_phone, priority, section_id, state, user_id, write_date, write_uid)
SELECT id, active, categ_id, company_id, create_date, create_uid, date_action_last, date_action_next, date_closed, date_open, date, description, duration, email_from, message_last_post, name, opportunity_id, partner_id, partner_mobile, partner_phone, priority, section_id, state, user_id, write_date, write_uid
FROM crm_phonecall



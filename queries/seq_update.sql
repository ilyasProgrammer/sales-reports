SELECT MAX(id) FROM mail_message;
SELECT nextval('mail_message_id_seq');
SELECT setval('mail_message_id_seq', (SELECT MAX(id) FROM mail_message));

SELECT MAX(id) FROM mail_alias;
SELECT nextval('mail_alias_id_seq');
SELECT setval('mail_alias_id_seq', (SELECT MAX(id) FROM mail_alias));

SELECT MAX(id) FROM res_partner;
SELECT nextval('res_partner_id_seq');
SELECT setval('res_partner_id_seq', (SELECT MAX(id) FROM res_partner));

SELECT MAX(id) FROM res_partner_title;
SELECT nextval('res_partner_title_id_seq');
SELECT setval('res_partner_title_id_seq', (SELECT MAX(id) FROM res_partner_title));

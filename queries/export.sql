CREATE TABLE rp(LIKE res_partner);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'res_partner';
  
INSERT INTO rp (id,
name,
lang,
company_id,
create_uid,
create_date,
write_date,
write_uid,
comment,
ean13,
color,
image,
use_parent_address,
active,
street,
supplier,
city,
user_id,
zip,
title,
function,
country_id,
parent_id,
employee,
type,
email,
vat,
website,
fax,
street2,
phone,
credit_limit,
date,
tz,
customer,
image_medium,
mobile,
ref,
image_small,
birthdate,
is_company,
state_id,
notification_email_send,
opt_out,
signup_type,
signup_expiration,
signup_token,
last_reconciliation_date,
debit_limit,
display_name,
vat_subjected,
section_id)
SELECT id,
name,
lang,
company_id,
create_uid,
create_date,
write_date,
write_uid,
comment,
ean13,
color,
image,
use_parent_address,
active,
street,
supplier,
city,
user_id,
zip,
title,
function,
country_id,
parent_id,
employee,
type,
email,
vat,
website,
fax,
street2,
phone,
credit_limit,
date,
tz,
customer,
image_medium,
mobile,
ref,
image_small,
birthdate,
is_company,
state_id,
notification_email_send,
opt_out,
signup_type,
signup_expiration,
signup_token,
last_reconciliation_date,
debit_limit,
display_name,
vat_subjected,
section_id
FROM res_partner;

'--------------------------------------'

CREATE TABLE ma (LIKE mail_alias);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_alias';
  
INSERT INTO ma (id,
create_uid,
create_date,
write_date,
write_uid,
alias_model_id,
alias_defaults,
alias_force_thread_id,
alias_name,
alias_user_id)
SELECT id,
create_uid,
create_date,
write_date,
write_uid,
alias_model_id,
alias_defaults,
alias_force_thread_id,
alias_name,
alias_user_id
FROM mail_alias;

'--------------------------------------'

CREATE TABLE ru (LIKE res_users);

SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'res_users';
  
 INSERT INTO ru (id,
active,
login,
password,
company_id,
partner_id,
create_uid,
create_date,
write_date,
write_uid,
menu_id,
login_date,
signature,
action_id,
alias_id,
share)
SELECT id,
active,
login,
password,
company_id,
partner_id,
create_uid,
create_date,
write_date,
write_uid,
menu_id,
login_date,
signature,
action_id,
alias_id,
share
FROM res_users;

'--------------------------------------'

CREATE TABLE mm (LIKE mail_message);

 INSERT INTO mm (id,
		create_uid,
		create_date,
		write_date,
		write_uid,
		body,
		model,
		record_name,
		date,
		subject,
		message_id,
		parent_id,
		res_id,
		subtype_id,
		author_id,
		type,
		email_from)
  SELECT
	    id,
	    create_uid,
	    create_date,
	    write_date,
	    write_uid,
	    body,
	    model,
	    record_name,
	    date,
	    subject,
	    message_id,
	    parent_id,
	    res_id,
	    subtype_id,
	    author_id,
	    type,
	    email_from
  FROM mail_message;




SELECT column_name ||','
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'mail_message'
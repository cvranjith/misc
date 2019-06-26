DECLARE
current_users 	VARCHAR2(24);
module_users	VARCHAR2(24);
module		varchar2(2);
no_of_licenses    number:=200;
BEGIN
module_users := smpkss.fn_encrypt_app_password ( to_char(no_of_licenses), 'CITIL');
current_users := smpkss.fn_encrypt_app_password ( to_char(0),'CITIL');
dbms_output.put_line ('No of license '||module_users);
dbms_output.put_line ('No of curr users '||current_users);
UPDATE smtbs_modules
SET MODULE_NO_USERS = module_users,
CURRENT_NO_USERS = current_users;
commit;
--where module_id= module;
END;
/


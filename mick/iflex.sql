define role_id='MAINTENANCE'
define user_id='IFLEX'
define branch_code='ALL'
UPDATE SMTB_USER
SET USER_STATUS = 'E',
NO_CUMULATIVE_LOGINS = 1,
NO_SUCCESSIVE_LOGINS = 0,
USER_PASSWORD = Fn_Encrypt_Fcj_Password ('PASSWORD',USER_ID),
FORCE_PASSWD_CHANGE = 0,
RECORD_STAT = 'O',
AUTH_STAT = 'A',
ONCE_AUTH = 'Y',
END_DATE = NULL,
START_DATE = TO_DATE('01-01-2000','DD-MM-RRRR'),
PWD_CHANGED_ON = (select today from sttm_dates where branch_Code = home_branch)
WHERE USER_ID = '&USER_ID'
/
delete smtb_current_users where user_id  ='&USER_ID';
@@addrole.sql
undef role_id,user_id,branch_code
commit;

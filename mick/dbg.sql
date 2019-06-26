UNDEF USER
SET VERIFY OFF
select * from cstb_debug_USERS WHERE USER_ID = 
DECODE(
UPPER('&&USER'),
'ALL',user_id,
'A',user_id,
'AL', user_id,
UPPER('&&USER')
)order by module
/
UNDEF USER
SET VERIFY ON

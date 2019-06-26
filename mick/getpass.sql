set serveroutput on;
declare
l_pwd	varchar2(100);
cursor cr_user is select * from smtbs_user where user_id=upper('&USER');
begin
for c1 in cr_user loop
select user_password into l_pwd from smtbs_user where user_id=c1.user_id;
l_pwd := smpkss.fn_decrypt_password ( c1.user_password , c1.user_id );
/*
UPDATE SMTBS_USER SET USER_PASSWORD = l_pwd ,
NO_CUMULATIVE_LOGINS = 0,
NO_SUCCESSIVE_LOGINS = 0,user_status = 'E'
where user_id = c1.user_id;*/
dbms_output.put_line('Got for ' || c1.user_id || ' '||c1.user_password||' '||l_pwd );
end loop;
--commit;
end;
/

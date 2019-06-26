set serverout on
undef UID
undef PWD
def uid = &User
def pwd = &Password
declare
uid varchar2(255);
pwd varchar2(255);
begin
	--uid := smpks.fn_encrypt_app_password('&&UID','CITIL');
	pwd := smpks.fn_encrypt_password('&&pwd','&&UID');
	dbms_output.put_line(pwd);
	update smtb_user set user_password = pwd
	where user_id = '&&UID';
	dbms_output.put_line('Rows Effected ' || sql%rowcount);
	commit;
end;
/

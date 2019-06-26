set serverout on
undef UID
undef PWD
undef DSN
def uid = &UID
def pwd = &PWD
def dsn = &DSN
declare
uid varchar2(255);
pwd varchar2(255);
dsn varchar2(255);
begin
	uid := smpks.fn_encrypt_app_password('&&UID','CITIL');
	pwd := smpks.fn_encrypt_app_password('&&PWD','&&UID');
	dsn := '&&DSN';
	dbms_output.put_line(uid || ';' || pwd || ';' || dsn);
/*	update moduleprofiletbl
	set connectinfo = uid || ';' || pwd || ';' || dsn;*/
end;
/

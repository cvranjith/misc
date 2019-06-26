-- to set flexcube password:
Declare
	r	varchar2(65);
--	uid1	varchar2(25);
	uid1	smtbs_user.user_id%TYPE;
	cnt	number(1);
Begin
	uid1 := upper('&UserId');
	select count(*) into cnt from smtbs_user where user_id = uid1;
	if cnt > 0 then
		r := smpks.FN_ENCRYPT_PASSWORD('PASSWORD',uid1);
 		dbms_output.put_line('The Encripted PASSWORD is '||r);
		update smtb_user set user_password = r, user_status = 'E' where user_id =uid1 ;
		commit;
		dbms_output.put_line('Password Reset for User '||uid1);
	else
		dbms_output.put_line('User '||uid1||' does not exist');
	end if;
Exception
	when others then
		dbms_output.put_line('In when others exception');

End;
/
DECLARE
l_clerk1_password varchar2(30);
l_clerk2_password varchar2(30);
l_password1	varchar2(20);
l_password2	varchar2(20);
BEGIN
	l_password1	:=	UPPER('&clerk1password');
	l_password2	:=	UPPER('&clerk2password');
	l_clerk1_password:=	smpkss.fn_encrypt_password(l_password1,'AAAAAA');
	l_clerk2_password:=	smpkss.fn_encrypt_password(l_password2,'ZZZZZZ');
	UPDATE smtbs_control_clerks
	SET		ctl_password_1	= 	l_clerk1_password
		,	ctl_password_2	= 	l_clerk2_password;
	IF	SQL%FOUND
	THEN
		dbms_output.put_line('Password changed');
	ELSE
		dbms_output.put_line('Could not find record to update');
	END IF;

	commit;
EXCEPTION
	WHEN OTHERS
	THEN
		dbms_output.put_line('In when others: '||sqlerrm);
END;
/

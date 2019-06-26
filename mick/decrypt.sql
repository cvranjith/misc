declare

un	varchar2(30);
user	varchar2(30);
password varchar2(30);
pw	varchar2(30);


Begin

	un := smpkss.fn_decrypt_password ( '&user' , 'CITIL' );

	pw := smpkss.fn_decrypt_password ('&password', UN);
	
dbms_output.put_line('decrypted user is'||un);
dbms_output.put_line('decrypted password'||pw);

end;
/

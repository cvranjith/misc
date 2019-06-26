	declare
		id	varchar2(50);
		pwd	varchar2(50);
	begin			
		id := smpkss.fn_encrypt_app_password ( UPPER('SHINSEI46'), UPPER('CITIL') );
		pwd := smpkss.fn_encrypt_app_password ( UPPER('SHINSEI46'), UPPER('SHINSEI46') );

		dbms_output.put_line('ID:  '||id);
		dbms_output.put_line('PWD: '||pwd);
	end;


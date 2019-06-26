accept x9dollar PROMPT 'Enter the new x9$ ==> '
begin
	update cstbs_param
	set param_val = upper('&x9dollar')
	where upper(param_name) = 'X9$';

	update cstbs_csm
	set param_name = smpkss.fn_encrypt_app_password('NORMAL',upper('$x9dollar'));

	commit;
end;
/

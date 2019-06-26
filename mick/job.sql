set serverout on size 1000000
begin 
loop
	begin
		dbms_output.put_line(to_char(sysdate,'HH24:MI:SS'));
	exception
		when others
		then
			null;
	end;
	mspkss.pr_bg_gen_msg_in;
	dbms_lock.sleep(60);
	if to_number(to_char(sysdate,'HH24MISS')) > '120000'
	then
		exit;
	end if;
end loop;
end;
/

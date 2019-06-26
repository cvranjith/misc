accept UserID PROMPT 'Enter the UserID (enter ~ for all users) ==> '
set serverout on size 1000000
declare
--uid varchar2(255);
pwd varchar2(255);
cursor c is
select distinct user_id from smtb_user
where upper(user_id) = upper(decode('&UserID','~',user_id,'&UserID'));
begin
	dbms_output.put_line('Resetting all pwds to PASSWORD123');
	dbms_output.put_line('---------------------------------');
	for eachc in c loop
		dbms_output.put_line('Resetting pwd for User ' || eachc.user_id);
		pwd := smpks.fn_encrypt_password('PASSWORD123',eachc.user_id);
		update smtb_user
		set user_password = pwd
		where user_id = eachc.user_id;
	end loop;
	dbms_output.put_line('committing.....');
	commit;
exception
	when others then
		dbms_output.put_line('Bombed....' || sqlerrm);
		dbms_output.put_line('No commit happened... rolling back');
		rollback;
end;
/

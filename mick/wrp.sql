declare
l_err 	VARCHAR2(1000);
l_brn	VARCHAR2(1000) := '&BRN';
l_func	VARCHAR2(1000) := '&FUNC';
l_orig  varchar2(1000);
l_par   varchar2(1000);
begin
global.pr_init(l_brn,'SYSTEM');
if l_func not like 'MARK%'
then
	begin
		select	null
		into	l_err
		from	eitb_pending_programs
		where	function_id = l_func
		and	branch_code = l_brn
		and	eoc_group = global.gBrnRec.end_of_input;
	exception
		when no_data_found
		then
			insert into eitb_pending_programs values (l_brn,global.gBrnRec.end_of_input,substr(l_func,1,2),l_func,'T');
	end;
	begin
	        select function_origin
		into   l_orig
		from   smtbs_menu
		where  function_id = l_func;
	exception
		when no_data_found
		then
			null;
	end;
end if;
if l_orig = 'CUSTOM'
then
	if not wrp_batch_custom.fn_run_batch(l_brn,global.user_id,'X',l_func,l_err,l_par)
	then
		l_err := nvl(l_err,'UNKNOWN-ERROR');
	end if;
else
	l_err := aepkss_batch.FN_EXECPROC (l_err, l_brn, 'SYSTEM', l_func);
end if;
dbms_output.put_line('Err '||l_err);
debug.pr_debug('LD','Err '||l_err);
if (l_func = 'MARKEOFI' and l_err = 'ED-10014')
            or (l_func = 'MARKTI'   and l_err = 'ED-10012')
            or (l_func = 'MARKEOD'  and l_err = 'ED-10032')
            or (l_func = 'MARKEOTI' and l_err = 'ED-10013')
then
	l_err := null;
end if;
if l_err is not null
then
	raise_application_error(-20001,'er - '||l_err);
end if;
END;
/

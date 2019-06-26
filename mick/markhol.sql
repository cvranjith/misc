
set serverout on size 1000000
declare
l_from		date := '&from_date';
l_to		date := '&to_date';
l_br		varchar2(3) := '&branch';
l_hol		varchar2(31);
l_today		date;
l_nwd		date;
l_nwd_c		date;
l_nwd_c1	date;
begin
--if l_from is not null or l_to is not null
--then
	if l_from is null
	then 
		if l_to is null
		then
			select 	distinct next_working_day
			into	l_from
			from	sttms_dates
			where	branch_code = decode(l_br,null,global.head_office,'ALL',global.head_office,l_br);
		else
			l_from := l_to;
		end if;
	end if;
	if l_to is null
	then
		l_to := l_from;
	end if;
	dbms_output.put_line('from '||l_from||' to '||l_to);
	for i in
		(
		select	a.*,
			to_date('01'||lpad(to_char(month),2,'0')||lpad(to_char(year),4,'0'),'DDMMYYYY') dt,
			a.rowid rid
		from	STTM_LCL_HOLIDAY a
		where	branch_code = decode(l_br,null,branch_code,'ALL',branch_code,l_br)
		and	to_date('01'||lpad(to_char(month),2,'0')||lpad(to_char(year),4,'0'),'DDMMYYYY') >= trunc(l_from,'MM')
		and	to_date('01'||lpad(to_char(month),2,'0')||lpad(to_char(year),4,'0'),'DDMMYYYY') <= trunc(l_to,'MM')
		)
	loop
		l_hol := null;
		for j in 1..to_number(to_char(last_day(i.dt),'DD'))
		loop
			if to_date( lpad(to_char(j),2,'0') || to_char(i.dt,'MMYYYY'),'DDMMYYYY') between l_from and l_to
			then
				l_hol := l_hol||'H';
				dbms_output.put_line('Marking Hol : '||i.branch_code||' '||to_date(lpad(to_char(j),2,'0') || to_char(i.dt,'MMYYYY'),'DDMMYYYY'));
			else
				l_hol := l_hol||substr(i.holiday_list,j,1);
			end if;
			--dbms_output.put_line(j||'==>'||l_hol);
		end loop;
		dbms_output.put_line('br '||i.branch_code||' year '||i.year||' month '||i.month||' '||i.holiday_list||' '||l_hol);
		update STTM_LCL_HOLIDAY set holiday_list = l_hol where rowid = i.rid;
	end loop;
	for i in
		(
		select	branch_code
			from sttm_branch
		where	branch_code = decode(l_br,null,branch_code,'ALL',branch_code,l_br)
		)
	loop
		global.pr_init(i.branch_code,'SYS');
		select	today,
			next_working_day
		into	l_today,
			l_nwd
		from	sttms_dates
		where	branch_code = i.branch_code;
		l_nwd_c := cepkss_date.fn_getworkingday('LCL', i.branch_Code,l_today,'N',1);
		if l_nwd != l_nwd_c
		then
			update	sttms_dates
			set	next_working_day = l_nwd_c
			where	branch_code = i.branch_Code;
			dbms_output.put_line('Updated nwd in sttms_dates '||i.branch_code||' '||l_nwd_c);
		end if;
		l_nwd_c1 := cepkss_date.fn_getworkingday('LCL', i.branch_Code,l_nwd_c,'N',1);
		select	today,
			next_working_day
		into	l_today,
			l_nwd
		from	sttms_aeod_dates
		where	branch_code = i.branch_code;
		if l_today != l_nwd_c or l_nwd != l_nwd_c1
		then
			update	sttms_aeod_dates
			set	today = l_nwd_c,
				next_working_day = l_nwd_c1
			where	branch_Code = i.branch_Code;
			dbms_output.put_line('Updated today/nwd in sttms_aeod_dates '||i.branch_code||' '||l_nwd_c||' '||l_nwd_c1);
		end if;
	end loop;
--end if;
end;
/



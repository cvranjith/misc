declare
d date := '&dt';
n date := '&nwd';
p date := '&pwd';
b varchar2(1000) := '&brn';
b_e varchar2(1) := '&eod_bod';
per varchar2(3);
fin varchar2(3);
begin

update sttm_DATES set today = d,
			next_working_day = n,
			prev_working_day = p
where branch_code = b;


update sttm_branch set CURRENT_PERIOD = 'M03', CURRENT_CYCLE = 'FY2004', end_of_input = b_e
where branch_code = b;

end;
/


declare
e varchar2(1000);
p varchar2(1000);
begin
global.pr_init('DBU','SYSTEM');
if not fapks_upload.FN_START
	(
	global.user_id,
	global.current_branch,
	'EXCEL',
	10000,
	e,
	p
	)
then
	raise_application_error(-20001,'er= '||e||' par='||p);
end if;
end;
/


select count(1),upload_status from fatb_contract_master_upload group by upload_status
/


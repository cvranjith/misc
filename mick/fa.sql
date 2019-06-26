set define off echo on feed on trimspo on termout off
spo /tmp/fa.log
delete FATBS_MIS_UPLOAD;
delete FATB_ASSET_ITEMS_UPLOAD;
delete FATBS_ADHOC_SCHEDULE_UPLOAD;
delete FATBS_CONTRACT_MASTER_UPLOAD;

@@/tmp/FATBS_MIS_UPLOAD.txt
@@/tmp/FATB_ASSET_ITEMS_UPLOAD.txt
@@/tmp/FATBS_ADHOC_SCHEDULE_UPLOAD.txt
@@/tmp/FATBS_CONTRACT_MASTER_UPLOAD.txt
commit;

select * from fatbs_mis_upload where busline is null or busline  not in (select mis_code from gltm_mis_code where mis_class = 'BUSLINE')
/

select * from fatbs_mis_upload where RSPCENTER not in (select mis_code from gltm_mis_code where mis_class = 'RSPCENTER')
/

select count(1), UPLOAD_STATUS,error_code from fatbs_contract_master_upload
group by UPLOAD_STATUS,error_code
/

/*
update fatbs_contract_master_upload
set UPLOAD_STATUS = 'U',
error_code =null
where upload_status = 'E'
and error_code is null
and rownum = 1
and external_ref_no = 'UAT-FU367'
*/

set termout on define on

declare
e varchar2(1000);
p varchar2(1000);
begin
global.pr_init('FCY','SYSTEM');
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

select count(1), UPLOAD_STATUS,error_code from fatbs_contract_master_upload
group by UPLOAD_STATUS,error_code
/



begin
for i in (select * from fatbs_mis_upload)
loop
for j in (select ASSET_REF_NO from FATB_CONTRACT_MASTER_UPLOAD where external_ref_no = i.external_ref_no)
loop
update mitb_class_mapping set txn_mis_1 = i.BUSLINE,txn_mis_2=i.RSPCENTER where unit_ref_no = j.ASSET_REF_NO;
end loop;
end loop;
end;
/


commit;

set numf 999999999999999999.9999 line 9999
select EXTERNAL_REF_NO,ASSET_COST,ACQUIRED_DEPRECIATION,RESIDUAL_VALUE,STATUS,error_code from fatbs_contract_master_upload where upload_status = 'E'
/

spo off


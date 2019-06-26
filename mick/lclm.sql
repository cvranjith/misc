create or replace procedure pr_lc_lm_rebuild
(
pContractRefNo	varchar2
)
is
l_ESN		number;
l_EventCode	varchar2(1000);
l_LCMasterRecord	LCTBS_CONTRACT_MASTER%ROWTYPE;
l_LCProductRecord LCTMS_PRODUCT_DEFINITION%ROWTYPE;
l_os_liability  number;
l_CurrentDate	date;
l_lstErrorCode   varchar2(1000);
l_lstErrorParam  varchar2(1000);
l_bool boolean;
begin

global.pr_init(substr(pContractRefNo,1,3),'SYSTEM');
l_CurrentDate := global.application_date;

for i in (select * from lctbs_Contract_master where contract_Ref_no = pContractRefNo order by event_seq_no desc)
loop
l_LCMasterRecord := i;
l_Esn := i.event_seq_no;
l_EventCode := i.event_code;

for j in (select * from LCTMS_PRODUCT_DEFINITION where product_code = substr(pContractRefNo,4,4))
loop
l_LCProductRecord := j;
end loop;

for j in (select OS_LIABILITY from lctbs_availments where contract_Ref_no = pContractRefNo  order by event_seq_no desc)
loop
l_os_liability   := j.OS_LIABILITY;
exit;
end loop;
l_Bool := LCPKSS_IFACE.fn_DoLimitUtilization
					(
					  pContractRefNo
					, l_ESN
					, l_EventCode
					, l_LCMasterRecord
					, l_LCProductRecord
					, 'LIAB_OS_AMT'
					, l_os_liability
					, 'A'
					, 'Y'
					, l_CurrentDate
					, l_lstErrorCode
					, l_lstErrorParam
					);
exit;
end loop;
end;
/


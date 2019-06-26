select contract_ref_no,err_code,event_seq_no
from cstb_contract_ovd
where ovd_status = 'U'
and contract_ref_no in (select a.contract_Ref_no from cstb_contract_event_log a where auth_status = 'U' and (maker_id like 'IFLEX%' or maker_id like 'RANJ%'))
/



update cstbs_contract_ovd
set    ovd_status = 'A'
where  ovd_Status = 'U'
and    contract_ref_no = '&ref'
/
 


undef crn user_id
update lctb_transfer_details set maker_id = '&&USER_ID' where FROM_LCREF= '&&CRN' and auth_status = 'U';
update cstbs_contract_event_log set maker_id = '&&USER_ID' where contract_ref_no = '&&CRN' and AUTH_STATUS = 'U';
UPDATE LDTB_CONTRACT_CONTROL SET ENTRY_BY = '&&USER_ID' WHERE CONTRACT_REF_NO = '&&CRN';
UPDATE CSTB_CONTRACT_CONTROL SET ENTRY_BY = '&&USER_ID' WHERE CONTRACT_REF_NO = '&&CRN';
update LCTB_AMND_VALS_MASTER set maker_id = '&&user_ID' where contract_reF_no = '&&CRN' and auth_stat = 'U';
update LCTB_transfer_details set maker_id = '&&user_ID' where FROM_LCREF = '&&CRN' and auth_status = 'U';



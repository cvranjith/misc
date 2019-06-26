UNDEF REF
delete fttb_upload_master WHERE SOURCE_REF = '&&REF';
delete cstb_ext_contract_stat WHERE EXTERNAL_REF_NO = '&&REF';
delete fttb_upload_activity WHERE SOURCE_REF = '&&REF';
delete fttb_upload_exception WHERE SOURCE_REF = '&&REF';

UNDEF REF
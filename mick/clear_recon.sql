undef DCN
delete mstb_dly_msg_in
where dcn = '&&DCN'
/

delete RETB_UPLOAD_STATEMENT
where UPLOAD_SOURCE_REF_NO = '&&DCN'
/

delete RETB_UPLOAD_ENTRY
where UPLOAD_SOURCE_REF_NO = '&&DCN'
/


delete retbs_external_statement
where UPLOAD_SOURCE_REF_NO = '&&DCN'
/

delete RETB_EXTERNAL_ENTRY
where EXTERNAL_ENTITY||EXTERNAL_ACCOUNT||to_char(STATEMENT_SEQ_NO)||to_char(STATEMENT_SUBSEQ_NO)
not in
(
select EXTERNAL_ENTITY||EXTERNAL_ACCOUNT||to_char(STATEMENT_SEQ_NO)||to_char(STATEMENT_SUBSEQ_NO) 
from RETB_EXTERNAL_STATEMENT
)
/

undef dcn


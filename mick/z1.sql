DECLARE
l_tb_hoff       	acpkss.tbl_AcHoff;
l_error_code            Varchar2(15);
l_error_param           Varchar2(300);
p_processing_date	Date;
idx                 NUMBER;
b                   BOOLEAN;
l_amt			number;
begin
GLOBAL.PR_INIT('100','SYSTEM');
for i in
(
select distinct TRN_REF_NO
from   TMP3
)
loop
  l_tb_hoff.delete;

  for eachrec in
  (
  select * from tmp3 where TRN_REF_NO = I.TRN_REF_NO --related_account = i.related_account
  )
  loop
      --DBMS_OUTPUT.PUT_LINE(EACHREC.TRN_REF_NO);
      idx := l_tb_hoff.COUNT+1;
	  l_tb_hoff(idx).MODULE        		      := eachrec.module;
	  l_tb_hoff(idx).TRN_REF_NO       	      := eachrec.TRN_REF_NO             ;
	  l_tb_hoff(idx).EVENT_SR_NO      	      := eachrec.EVENT_SR_NO            ;
	  l_tb_hoff(idx).EVENT                  	      := eachrec.EVENT;
	  l_tb_hoff(idx).AC_BRANCH              	      := eachrec.AC_BRANCH              ;
	  l_tb_hoff(idx).AC_NO                  	      := eachrec.AC_NO                  ;
	  l_tb_hoff(idx).AC_CCY                 	      := eachrec.AC_CCY                 ;
	  l_tb_hoff(idx).DRCR_IND               	      := eachrec.DRCR_IND               ;
	  l_tb_hoff(idx).TRN_CODE               	      := eachrec.TRN_CODE               ;
	  l_tb_hoff(idx).AMOUNT_TAG             	      := eachrec.AMOUNT_TAG             ;
	  l_tb_hoff(idx).RELATED_CUSTOMER       	      := eachrec.RELATED_CUSTOMER       ;
	  l_tb_hoff(idx).RELATED_ACCOUNT        	      := eachrec.RELATED_ACCOUNT        ;
	  l_tb_hoff(idx).RELATED_REFERENCE      	      := eachrec.ac_entry_sr_no;
	  l_tb_hoff(idx).MIS_FLAG               	      := eachrec.MIS_FLAG               ;
	  l_tb_hoff(idx).MIS_HEAD               	      := eachrec.MIS_HEAD               ;
	  l_tb_hoff(idx).TRN_DT                 	      := eachrec.TRN_DT                 ;
	  l_tb_hoff(idx).VALUE_DT               	      := eachrec.VALUE_DT               ;
	  l_tb_hoff(idx).TXN_INIT_DATE          	      := eachrec.TXN_INIT_DATE          ;
	  l_tb_hoff(idx).FINANCIAL_CYCLE        	      := eachrec.FINANCIAL_CYCLE        ;
	  l_tb_hoff(idx).PERIOD_CODE            	      := eachrec.PERIOD_CODE            ;
	  l_tb_hoff(idx).INSTRUMENT_CODE        	      := eachrec.INSTRUMENT_CODE        ;
	  l_tb_hoff(idx).BATCH_NO               	      := eachrec.BATCH_NO               ;
	  l_tb_hoff(idx).CURR_NO                	      := eachrec.CURR_NO                ;
	  l_tb_hoff(idx).USER_ID                	      := eachrec.USER_ID                ;
	  l_tb_hoff(idx).BANK_CODE              	      := eachrec.BANK_CODE              ;
	  l_tb_hoff(idx).AUTH_ID                	      := eachrec.AUTH_ID                ;
	  l_tb_hoff(idx).AUTH_STAT              	      := 'A';
	  l_tb_hoff(idx).CATEGORY               	      := eachrec.CATEGORY               ;
	  l_tb_hoff(idx).CUST_GL                	      := eachrec.CUST_GL                ;
	  l_tb_hoff(idx).NETTING_IND            	      := 'N';
	  l_tb_hoff(idx).PRODUCT                	      := eachrec.PRODUCT                ;
	  l_tb_hoff(idx).EXTERNAL_REF_NO        	      := eachrec.EXTERNAL_REF_NO        ;
	  l_tb_hoff(idx).DONT_SHOWIN_STMT       	      := eachrec.DONT_SHOWIN_STMT       ;
	  l_tb_hoff(idx).fcy_amount := 1* eachrec.fcy_amount;
	  l_tb_hoff(idx).exch_rate                      := eachrec.exch_rate;
	  l_tb_hoff(idx).ac_ccy                         := eachrec.ac_ccy;
	  l_tb_hoff(idx).drcr_ind                       := eachrec.drcr_ind;
	  l_tb_hoff(idx).LCY_AMOUNT             	      := 1* eachrec.lcy_amount;
end loop;
dbms_output.put_line('BEFORE HAND '||l_tb_hoff.COUNT);
     	  b := acpkss.fn_achandoff(l_tb_hoff(1).trn_ref_no,
     				 l_tb_hoff(1).event_sr_no,
     				 GLOBAL.application_date,
     				 l_tb_hoff,
     				 'B',
     				 'Y',
     				 'Y',
     				 'SYSTEM',
     				 l_error_code,
     				 l_error_param
     				 );
dbms_output.put_line(l_tb_hoff.COUNT);
IF NOT B THEN dbms_output.put_line('NOT B '||L_ERROR_CODE); END IF;
end loop;
end;
/

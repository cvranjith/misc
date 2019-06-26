DECLARE
l_tb_hoff       	acpkss.tbl_AcHoff;
l_error_code            Varchar2(15);
l_error_param           Varchar2(300);
p_processing_date	Date;
idx                 NUMBER;
b                   BOOLEAN;
begin
  GLOBAL.PR_INIT('009','SYSTEM');
  l_tb_hoff.delete;
  For eachrec IN 
  (
SELECT * FROM DETB_UPLOAD_DETAIL
WHERE BATCH_NO = '7777'
  )
  LOOP
      idx := l_tb_hoff.COUNT+1;
	  l_tb_hoff(idx).MODULE        		      := eachrec.MODULE                 ;
	  l_tb_hoff(idx).TRN_REF_NO       	      := eachrec.TRN_REF_NO             ;
	  l_tb_hoff(idx).EVENT_SR_NO      	      := eachrec.EVENT_SR_NO            ;
	  l_tb_hoff(idx).EVENT                  	      := eachrec.EVENT;
	  l_tb_hoff(idx).AC_BRANCH              	      := eachrec.BRANCH_CODE              ;
	  l_tb_hoff(idx).AC_NO                  	      := eachrec.ACCOUNT                  ;
	  l_tb_hoff(idx).AC_CCY                 	      := eachrec.CCY_CD                 ;
	  l_tb_hoff(idx).DRCR_IND               	      := eachrec.DR_CR               ;
	  l_tb_hoff(idx).TRN_CODE               	      := eachrec.TXN_CODE               ;
	  l_tb_hoff(idx).AMOUNT_TAG             	      := eachrec.AMOUNT_TAG             ;
	  l_tb_hoff(idx).RELATED_CUSTOMER       	      := eachrec.REL_CUST;
	  l_tb_hoff(idx).RELATED_ACCOUNT        	      := eachrec.RELATED_ACCOUNT        ;
	  l_tb_hoff(idx).RELATED_REFERENCE      	      := eachrec.ac_entry_sr_no;
	  l_tb_hoff(idx).MIS_FLAG               	      := eachrec.MIS_FLAG               ;
	  l_tb_hoff(idx).MIS_HEAD               	      := eachrec.MIS_HEAD               ;
	  l_tb_hoff(idx).TRN_DT                 	      := eachrec.INITIATION_DATE                 ;
	  l_tb_hoff(idx).VALUE_DT               	      := eachrec.VALUE_DATE               ;
	  l_tb_hoff(idx).TXN_INIT_DATE          	      := eachrec.INITIATION_DATE;
	  l_tb_hoff(idx).FINANCIAL_CYCLE        	      := eachrec.FIN_CYCLE        ;
	  l_tb_hoff(idx).PERIOD_CODE            	      := eachrec.PERIOD_CODE            ;
	  l_tb_hoff(idx).INSTRUMENT_CODE        	      := eachrec.INSTRUMENT_NO        ;
	  l_tb_hoff(idx).BATCH_NO               	      := eachrec.BATCH_NO               ;
	  l_tb_hoff(idx).CURR_NO                	      := eachrec.CURR_NO                ;
	  l_tb_hoff(idx).USER_ID                	      := 'SYSTEM';
	  l_tb_hoff(idx).AUTH_ID                	      := 'SYSTEM';
	  l_tb_hoff(idx).PRINT_STAT             	      := 'N';
	  l_tb_hoff(idx).AUTH_STAT              	      := 'A';
	  l_tb_hoff(idx).CATEGORY               	      := eachrec.CATEGORY               ;
	  l_tb_hoff(idx).CUST_GL                	      := eachrec.CUST_GL                ;
	  l_tb_hoff(idx).NETTING_IND            	      := 'N';
	  l_tb_hoff(idx).PRODUCT                	      := eachrec.PRODUCT_CODE                ;
	  l_tb_hoff(idx).EXTERNAL_REF_NO        	      := eachrec.EXTERNAL_REF_NO        ;
	  l_tb_hoff(idx).DONT_SHOWIN_STMT       	      := 'N';
      l_tb_hoff(idx).fcy_amount                     := eachrec.amount;
      l_tb_hoff(idx).exch_rate                      := eachrec.exch_rate;
      l_tb_hoff(idx).ac_ccy                         := eachrec.ccy_cd;
      l_tb_hoff(idx).drcr_ind                       := eachrec.dr_cr;
	  l_tb_hoff(idx).LCY_AMOUNT             	      := eachrec.LCY_EQUIVALENT;      
	  l_tb_hoff(idx).GAAP_INDICATOR             	      := eachrec.GAAP_INDICATOR;      
	  l_tb_hoff(idx).GLOBAL_GL_CODE             	      := eachrec.GLOBAL_GL_CODE;      
  END LOOP;

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
end;
/

DECLARE
	l_tb_hoff_base	ACPKSS.tbl_AcHoff;
	l_tb_hoff	ACPKSS.tbl_AcHoff;
	p_branch  	VARCHAR2 (3) := '035';
	p_error_code 	VARCHAR2(2000);
	p_error_param 	VARCHAR2(2000);

BEGIN
	GLOBAL.pr_init('035','SYSTEM02');
	
	FOR EACHREC IN
		(
		SELECT	*
		FROM	ACTB_HISTORY
		WHERE	RELATED_ACCOUNT = '000028340001'
		AND	FCY_AMOUNT < 0
		AND	AC_NO = '204912002'
		AND	EVENT = 'IACR'
		)
	LOOP
			l_tb_hoff_base(1).MODULE        		:= eachrec.MODULE                 ;
	  		l_tb_hoff_base(1).TRN_REF_NO       	        := eachrec.TRN_REF_NO             ;
	  		l_tb_hoff_base(1).EVENT_SR_NO      	        := eachrec.EVENT_SR_NO            ;
		  	l_tb_hoff_base(1).EVENT                  	:= 'RPOS'                         ;
	  		l_tb_hoff_base(1).AC_BRANCH              	:= eachrec.AC_BRANCH              ;
	  		l_tb_hoff_base(1).AC_NO                  	:= eachrec.AC_NO                  ;
	  		l_tb_hoff_base(1).AC_CCY                 	:= eachrec.AC_CCY                 ;
	  		l_tb_hoff_base(1).DRCR_IND               	:= eachrec.DRCR_IND               ;
	  		l_tb_hoff_base(1).TRN_CODE               	:= eachrec.TRN_CODE               ;
	  		l_tb_hoff_base(1).AMOUNT_TAG             	:= eachrec.AMOUNT_TAG             ;
	  		l_tb_hoff_base(1).FCY_AMOUNT             	:= eachrec.FCY_AMOUNT             ;
	  		l_tb_hoff_base(1).EXCH_RATE              	:= eachrec.EXCH_RATE              ;
	  		l_tb_hoff_base(1).LCY_AMOUNT             	:= eachrec.LCY_AMOUNT             ;
	  		l_tb_hoff_base(1).RELATED_CUSTOMER       	:= eachrec.RELATED_CUSTOMER       ;
	  		l_tb_hoff_base(1).RELATED_ACCOUNT        	:= eachrec.RELATED_ACCOUNT        ;
	  		l_tb_hoff_base(1).RELATED_REFERENCE      	:= eachrec.RELATED_REFERENCE      ;
	  		l_tb_hoff_base(1).MIS_FLAG               	:= eachrec.MIS_FLAG               ;
	  		l_tb_hoff_base(1).MIS_HEAD               	:= eachrec.MIS_HEAD               ;
	  		l_tb_hoff_base(1).VALUE_DT               	:= eachrec.VALUE_DT               ;
	  		l_tb_hoff_base(1).TXN_INIT_DATE          	:= eachrec.TXN_INIT_DATE          ;
	  		l_tb_hoff_base(1).FINANCIAL_CYCLE        	:= eachrec.FINANCIAL_CYCLE        ;
		  	l_tb_hoff_base(1).PERIOD_CODE            	:= eachrec.PERIOD_CODE            ;
	  		l_tb_hoff_base(1).INSTRUMENT_CODE        	:= eachrec.INSTRUMENT_CODE        ;
	  		l_tb_hoff_base(1).BATCH_NO               	:= eachrec.BATCH_NO               ;
	  		l_tb_hoff_base(1).CURR_NO                	:= eachrec.CURR_NO                ;
	  		l_tb_hoff_base(1).USER_ID                	:= eachrec.USER_ID                ;
	  		l_tb_hoff_base(1).BANK_CODE              	:= eachrec.BANK_CODE              ;
	  		l_tb_hoff_base(1).TYPE                   	:= eachrec.TYPE                   ;
	  		l_tb_hoff_base(1).AUTH_ID                	:= eachrec.AUTH_ID                ;
	  		l_tb_hoff_base(1).PRINT_STAT             	:= eachrec.PRINT_STAT             ;
	  		l_tb_hoff_base(1).AUTH_STAT              	:= 'A'                            ;
	  		l_tb_hoff_base(1).CATEGORY               	:= eachrec.CATEGORY               ;
	  		l_tb_hoff_base(1).CUST_GL                	:= eachrec.CUST_GL                ;
	  		l_tb_hoff_base(1).NETTING_IND            	:= 'N'                            ;
	  		l_tb_hoff_base(1).PRODUCT_ACCRUAL        	:= eachrec.PRODUCT_ACCRUAL        ;
	  		l_tb_hoff_base(1).PRODUCT                	:= eachrec.PRODUCT                ;
	  		l_tb_hoff_base(1).EXTERNAL_REF_NO        	:= eachrec.EXTERNAL_REF_NO        ;
	  		l_tb_hoff_base(1).DONT_SHOWIN_STMT       	:= eachrec.DONT_SHOWIN_STMT       ;
	  		l_tb_hoff_base(1).IC_BAL_INCLUSION       	:= eachrec.IC_BAL_INCLUSION       ;
	  		l_tb_hoff_base(1).AML_EXCEPTION          	:= eachrec.AML_EXCEPTION          ;
			l_tb_hoff_base(1).trn_dt          		:= GLOBAL.application_date;
			EXIT;
	END LOOP;
	
	l_tb_hoff(1) 		:= l_tb_hoff_base(1);
	l_tb_hoff(1).trn_ref_no := '035ISA1051030005';
	l_tb_hoff(1).event 	:= 'RPOS';
	l_tb_hoff(1).amount_tag := 'IACR_LCY_ADJ';
	l_tb_hoff(1).ac_ccy 	:= GLOBAL.lcy;
	l_tb_hoff(1).fcy_amount := NULL;
	l_tb_hoff(1).exch_rate 	:= NULL;
	l_tb_hoff(1).lcy_amount := 3;
	l_tb_hoff(1).drcr_ind 	:= 'C';
	l_tb_hoff(1).ac_no 	:= '204912001';

	
	l_tb_hoff(2) 		:= l_tb_hoff_base(1);
	l_tb_hoff(2).trn_ref_no := '035ISA1051030005';
	l_tb_hoff(2).event 	:= 'RPOS';
	l_tb_hoff(2).amount_tag := 'IACR_LCY_ADJ';
	l_tb_hoff(2).ac_ccy 	:= GLOBAL.lcy;
	l_tb_hoff(2).fcy_amount := NULL;
	l_tb_hoff(2).exch_rate 	:= NULL;
	l_tb_hoff(2).lcy_amount := 3;
	l_tb_hoff(2).drcr_ind 	:= 'D';
	l_tb_hoff(2).ac_no 	:= '408011003';
	
	l_tb_hoff(3) 		:= l_tb_hoff_base(1);
	l_tb_hoff(3).trn_ref_no := '035ITD1051040067';
	l_tb_hoff(3).event 	:= 'RPOS';
	l_tb_hoff(3).amount_tag := 'IACR_LCY_ADJ';
	l_tb_hoff(3).ac_ccy 	:= GLOBAL.lcy;
	l_tb_hoff(3).fcy_amount := NULL;
	l_tb_hoff(3).exch_rate 	:= NULL;
	l_tb_hoff(3).lcy_amount := 1;
	l_tb_hoff(3).drcr_ind 	:= 'C';
	l_tb_hoff(3).ac_no 	:= '204912002';
	
	l_tb_hoff(4) 		:= l_tb_hoff_base(1);
	l_tb_hoff(4).trn_ref_no := '035ITD1051040067';
	l_tb_hoff(4).event 	:= 'RPOS';
	l_tb_hoff(4).amount_tag := 'IACR_LCY_ADJ';
	l_tb_hoff(4).ac_ccy 	:= GLOBAL.lcy;
	l_tb_hoff(4).fcy_amount := NULL;
	l_tb_hoff(4).exch_rate 	:= NULL;
	l_tb_hoff(4).lcy_amount := 1;
	l_tb_hoff(4).drcr_ind 	:= 'D';
	l_tb_hoff(4).ac_no 	:= '408011004';

	IF l_tb_hoff.COUNT > 0
	THEN
		FOR i IN l_tb_hoff.FIRST .. l_tb_hoff.LAST
		LOOP
			DBMS_OUTPUT.put_line( l_tb_hoff(i).trn_ref_no || '~'|| l_tb_hoff(i).ac_no || '~' || l_tb_hoff(i).lcy_amount || '~'||l_tb_hoff(i).drcr_ind);
		END LOOP;
		IF NOT acpkss.fn_achandoff
				(
				l_tb_hoff(1).trn_ref_no,
				l_tb_hoff(1).event_sr_no,
				GLOBAL.application_date,
				l_tb_hoff,
				'B',
				'Y',
				'Y',
				GLOBAL.user_id,
				p_error_code,
				p_error_param
				)
		THEN
			DEBUG.pr_debug('GL','ACPKS.fn_achandoff returned FALSE '||p_error_code);
		END IF;
	END IF;
END;
/

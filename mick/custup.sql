DECLARE
l_cust_tb				STTMS_UPLOAD_CUSTOMER%ROWTYPE;
l_custprs_tb			STTMS_UPLOAD_CUST_PERSONAL%ROWTYPE;
l_custno				STTMS_CUSTOMER.CUSTOMER_NO%TYPE;
L_NUM				NUMBER := 0;
BEGIN
	DELETE	STTMS_UPLOAD_CUSTOMER
	WHERE	CUSTOMER_NO <> '49654';
	DELETE	STTMS_UPLOAD_CUST_PERSONAL
	WHERE	CUSTOMER_NO <> '49654';
	SELECT	*
	INTO	l_cust_tb
	FROM	STTMS_UPLOAD_CUSTOMER
	WHERE	CUSTOMER_NO = '49654';
	SELECT	*
	INTO	l_custprs_tb
	FROM	STTMS_UPLOAD_CUST_PERSONAL
	WHERE	CUSTOMER_NO = '49654';
	FOR I IN 1..10000
	LOOP
		L_NUM := L_NUM + 1;
		IF L_NUM = 1000 THEN
			L_NUM := 0;
			COMMIT;
		END IF;
		SELECT	CESQ_CIF_ID.NEXTVAL
		INTO	l_custno
		FROM	DUAL;
		INSERT INTO STTMS_UPLOAD_CUSTOMER
			(
			source_code,
			maintenance_seq_no,
			customer_no,
			customer_type,
			customer_name1,
			address_line1,
			address_line3,
			address_line2,
			address_line4,
			country,
			short_name,
			nationality,
			language,
			exposure_country,
			local_branch,
			liability_no,
			unique_id_name,
			unique_id_value,
			frozen,
			deceased,
			whereabouts_unknown,
			customer_category,
			ho_ac_no,
			fx_cust_clean_risk_limit,
			overall_limit,
			fx_clean_risk_limit,
			credit_rating,
			revision_date,
			limit_ccy,
			cas_cust,
			conversion_status_flag,
			err_msg,
			sec_cust_clean_risk_limit,
			sec_clean_risk_limit,
			sec_cust_pstl_risk_limit,
			sec_pstl_risk_limit,
			default_media,
			liab_node,
			liab_br
			)
		VALUES
			(
			l_cust_tb.source_code,
			l_cust_tb.maintenance_seq_no,
			l_custno,
			l_cust_tb.customer_type,
			l_cust_tb.customer_name1||' * '||l_custno,
			l_cust_tb.address_line1||' * '||l_custno,
			l_cust_tb.address_line3||' * '||l_custno,
			l_cust_tb.address_line2||' * '||l_custno,
			l_cust_tb.address_line4||' * '||l_custno,
			l_cust_tb.country,
			l_cust_tb.short_name||' * '||l_custno,
			l_cust_tb.nationality,
			l_cust_tb.language,
			l_cust_tb.exposure_country,
			l_cust_tb.local_branch,
			l_cust_tb.liability_no,
			l_cust_tb.unique_id_name,
			l_cust_tb.unique_id_value,
			l_cust_tb.frozen,
			l_cust_tb.deceased,
			l_cust_tb.whereabouts_unknown,
			l_cust_tb.customer_category,
			'',
			l_cust_tb.fx_cust_clean_risk_limit,
			l_cust_tb.overall_limit,
			l_cust_tb.fx_clean_risk_limit,
			l_cust_tb.credit_rating,
			l_cust_tb.revision_date,
			l_cust_tb.limit_ccy,
			l_cust_tb.cas_cust,
			'X',
			l_cust_tb.err_msg,
			l_cust_tb.sec_cust_clean_risk_limit,
			l_cust_tb.sec_clean_risk_limit,
			l_cust_tb.sec_cust_pstl_risk_limit,
			l_cust_tb.sec_pstl_risk_limit,
			l_cust_tb.default_media,
			l_cust_tb.liab_node,
			l_cust_tb.liab_br
			);
		INSERT INTO STTMS_UPLOAD_CUST_PERSONAL
			(
			customer_prefix,
			first_name,
			middle_name,
			last_name,
			date_of_birth,
			legal_guardian,
			minor,
			sex,
			p_national_id,
			passport_no,
			ppt_iss_date,
			ppt_exp_date,
			d_address1,
			d_address2,
			d_address3,
			telephone,
			fax,
			e_mail,
			p_address1,
			p_address3,
			p_address2,
			customer_no,
			d_country,
			p_country,
			resident_status,
			conversion_status_flag,
			err_msg
			)
		VALUES
			(
			l_custprs_tb.customer_prefix,
			l_custprs_tb.first_name||' * '||l_custno,
			l_custprs_tb.middle_name||' * '||l_custno,
			l_custprs_tb.last_name||' * '||l_custno,
			l_custprs_tb.date_of_birth,
			l_custprs_tb.legal_guardian,
			l_custprs_tb.minor,
			l_custprs_tb.sex,
			l_custprs_tb.p_national_id,
			l_custprs_tb.passport_no,
			l_custprs_tb.ppt_iss_date,
			l_custprs_tb.ppt_exp_date,
			l_custprs_tb.d_address1,
			l_custprs_tb.d_address2,
			l_custprs_tb.d_address3,
			l_custprs_tb.telephone,
			l_custprs_tb.fax,
			l_custprs_tb.e_mail,
			l_custprs_tb.p_address1,
			l_custprs_tb.p_address3,
			l_custprs_tb.p_address2,
			l_custno,
			l_custprs_tb.d_country,
			l_custprs_tb.p_country,
			l_custprs_tb.resident_status,
			'X',
			l_custprs_tb.err_msg
			);
	END LOOP;
END;
/

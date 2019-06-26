DECLARE
	p_source_code		cstbs_ext_contract_stat.source%TYPE := 'FCRH';
	p_uploaded_status	cotms_source_pref.uploaded_status%TYPE := 'A';
	p_on_error		cotms_source_pref.on_error%TYPE := 'R';
	p_on_override		cotms_source_pref.on_override%TYPE := 'I';
	p_upload_id		cstbs_upload_log.upload_id%TYPE;
	p_error_code		VARCHAR2(1000);
	p_error_parameter	VARCHAR2(1000);
begin
GLOBAL.PR_INIT('MUM','HATH');
IF NOT ldpks_upload_payment_0.fn_upload_for_a_branch
	(
	p_source_code,
	p_uploaded_status,
	p_on_error,
	p_on_override,
	p_upload_id,
	p_error_code,
	p_error_parameter
	)
THEN
	DBMS_OUTPUT.PUT_LINE('HATH' ||P_ERROR_CODE||'  '||p_ERROR_PARAMETER);
END IF;
END;
/

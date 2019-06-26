DECLARE
	p_upload_id	cstbs_upload_log.upload_id%TYPE;
	p_error_code		varchar2(100);
	p_error_parameter	varchar2(1000);

BEGIN
global.pr_init('MUM','HATH');
IF NOT ldpks_upload_amendment_1.fn_upload_for_a_branch
	(
	'UFJCONVLD'
	,	'MUM'
	,	'A'
	,	'R'
	,	'I'
	,	p_upload_id
	,	p_error_code
	,	p_error_parameter
	)
then
dbms_output.put_line('erro '||p_error_code||' '||p_error_parameter);
END IF;
END;
/


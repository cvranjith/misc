DECLARE
	l_lcy		VARCHAR2(3);
	l_rate		NUMBER;
	l_rate_flag	NUMBER;
	l_err		VARCHAR2(1000);
	l_brn		varchar2(100) := '869';
 l_dt date := '31-OCT-2009';
BEGIN
	GLOBAL.PR_INIT(l_brn,'SYSTEM');
	l_lcy := GLOBAL.lcy;
	IF NOT cypks.fn_getrate
		(
		GLOBAL.CURRENT_BRANCH,
		'EUR',
		'USD',
                l_dt,
                global.application_date, 
		l_rate,
		l_rate_flag,
		l_err
		)
	THEN
		l_rate := NULL;
	END IF;
dbms_output.put_line(l_rate);
END;
/

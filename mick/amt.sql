set serverout on size 1000000
UNDEFINE CCY1
UNDEFINE CCY2
DECLARE
	l_lcy		VARCHAR2(3);
	l_rate		NUMBER;
	l_rate_flag	NUMBER;
	l_err		VARCHAR2(1000);
	l_brn		varchar2(100) := '&brn';
	l_amt		NUMBER := '&AMT';
BEGIN
	GLOBAL.PR_INIT(l_brn,'SYSTEM');
	l_lcy := GLOBAL.lcy;
	IF NOT cypks.fn_getrate
		(
		GLOBAL.CURRENT_BRANCH,
		'&&CCY1',
		'&&CCY2',
		nvl('&RATE_TYPE','STANDARD'),
		nvl('&BUY_SEL','M'),
		l_rate,
		l_rate_flag,
		l_err
		)
	THEN
		l_rate := NULL;
	END IF;


	DBMS_OUTPUT.PUT_LINE('RATE '||l_rate||l_err);
	IF NOT CYPKS.FN_AMT1_TO_AMT2
		(
		'&&CCY1',
		'&&CCY2',
		L_AMT,
		l_rate,
		'N',
		l_amt,
		l_err
		)
	THEN
		NULL;
	END IF;
	DBMS_OUTPUT.PUT_LINE('amt  '||l_AMT||l_err);
/*EXCEPTION
	WHEN OTHERS
	THEN
	L_ERR := SQLERRM;
		DBMS_OUTPUT.PUT_LINE('ERROR '||sqlerrm);*/
END;
/
UNDEFINE CCY1
UNDEFINE CCY2
SET VERIFY ON

SET VERIFY OFF SERVEROUT ON SIZE 1000000
UNDEFINE CCY
DECLARE
	l_lcy		VARCHAR2(3);
	l_rate		NUMBER;
	l_rate_flag	NUMBER;
	l_err		VARCHAR2(100);
	l_amt		NUMBER;
BEGIN
	l_lcy := GLOBAL.lcy;
	IF NOT cypks.fn_getrate
		(
		'400',
		'&&CCY',
		l_lcy,
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
		'&&CCY',
		l_lcy,
		&PAMOUNT1,
		l_rate,
		'Y',
		l_amt,
		l_err
		)
	THEN
		l_amt := NULL;
	END IF;
	DBMS_OUTPUT.PUT_LINE('LCY EQ  '||l_AMT||l_err);
EXCEPTION
	WHEN OTHERS
	THEN
		DBMS_OUTPUT.PUT_LINE('ERROR '||sqlerrm);
END;
/
UNDEFINE CCY
SET VERIFY ON

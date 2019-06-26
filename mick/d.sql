SET SERVEROUT ON SIZE 1000000 VERIFY OFF
DECLARE
D NUMBER;
M NUMBER;
Y NUMBER;
F date := to_date('&from_dt');
T date := to_date('&to_dt');
BEGIN

icpkss_calc.g_ictm_acc.INT_START_DATE := F;

ICPKS_UTIL.pr_get_days(
		f,
		t-1,
		'1',
		d,
		m,
		y);
DBMS_OUTPUT.PUT_LINE('DAYS IS -> '||D);
ICPKS_UTIL.pr_get_days(
		T-1,
		t,
		'1',
		d,
		m,
		y);
DBMS_OUTPUT.PUT_LINE('DAYS IS -> '||D);
END;
/


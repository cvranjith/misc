@storeset
SET SERVEROUT ON SIZE 1000000 VERIFY OFF FEED OFF

UNDEFINE RRULE NODEC RUNIT

PROMPT +--------------------------------------------------------------------------+
PROMPT |
PROMPT |  Enter Rounding Rule .. 
PROMPT |       [Choices below]
PROMPT |
PROMPT |       T - Truncate
PROMPT |       U - Up
PROMPT |       D - Down
PROMPT |       N - Round Near
PROMPT |
ACCEPT RRULE CHAR PROMPT '|       Your Choice                ==> '
ACCEPT NODEC CHAR PROMPT '|       Enter Number of Decimals   ==> '
ACCEPT RUNIT CHAR PROMPT '|       Enter Rounding Unit        ==> '
PROMPT |
ACCEPT AMOUN CHAR PROMPT '|       Enter Amount               ==> '
PROMPT |
PROMPT |
PROMPT +--------------------------------------------------------------------------+
PROMPT |
PROMPT |
DECLARE
  TMP_NUMBER NUMBER := 0;
BEGIN
  LDPKSS_GLOBAL.ld_round_rule := UPPER('&RRULE');
  LDPKSS_GLOBAL.ld_round_decimals := &NODEC;
  LDPKSS_GLOBAL.ld_round_unit := &RUNIT;
  IF GLOBAL.CURRENT_BRANCH IS NULL THEN GLOBAL.PR_INIT(GLOBAL.HEAD_OFFICE,'SYSTEM');END IF;
  IF NOT Cypks.fn_amt_round (GLOBAL.lcy,'&amoun',tmp_number) THEN
  	DBMS_OUTPUT.PUT_LINE('| FAILED ');
  END IF; 
  DBMS_OUTPUT.PUT_LINE('| ****  ROUNDED AMT IS '||tmp_number);
END;
/
PROMPT |
PROMPT |
PROMPT +--------------------------------------------------------------------------+
@restoreset


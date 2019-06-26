-- check-digit is calculated using standard
-- oscillating arithmetical progressive series for the
-- weights by which the characters of the given string
-- are multiplied

DECLARE
	str			VARCHAR2(100) := '&STRING';
	chk_sum			NUMBER := 0;
	mod_wgt			NUMBER := 0;
	chr_wgt			NUMBER := 0;
	chk_dgt			NUMBER := 0;
BEGIN
	FOR i IN 1..LENGTH(str)
	LOOP
		chr_wgt := ASCII(SUBSTR(str,i,1));
		IF mod_wgt <= FLOOR(11/2)
		THEN
			mod_wgt := mod_wgt+1;
		ELSIF mod_wgt = FLOOR(11/2)+1
		THEN
			mod_wgt := 11;
		ELSE
			mod_wgt := mod_wgt-1;
		END IF;							
		chk_sum := chk_sum + (chr_wgt*mod_wgt);
	END LOOP;
	chk_dgt := MOD(chk_sum, 11);
	DBMS_OUTPUT.put_line('CHECK DIGIT IS ==> '||chk_dgt);
END;
/

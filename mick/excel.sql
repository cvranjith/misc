SET VERIFY OFF SERVEROUT ON SIZE 1000000 LINE 9999 TRIMSPOOL ON feed off
spool tmp.tmp
DECLARE
X VARCHAR2(1) := upper('&ABCD');

Y VARCHAR2(1000);

BEGIN
IF ASCII(X) NOT BETWEEN 65 AND 90 THEN RETURN; END IF;

FOR i IN 65 .. 90
LOOP
	Y := Y||(CHR(I)||'1,"'',''",');
	IF ASCII(X) = i
	THEN
		EXIT;
	END IF;
END LOOP;

y := substr(y,1,length(y)-7);


DBMS_OUTPUT.PUT_LINE('=CONCATENATE('||REPLACE(Y,CHR(39))||')');
DBMS_OUTPUT.PUT_LINE('=CONCATENATE("insert into **TAB** values (''",'||Y||',"'');")');

END;
/

spool off
SET VERIFY ON feed on

ed tmp.tmp
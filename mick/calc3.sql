CL SCR
UNDEFINE ACCOUNT
UNDEFINE FROM_DATE
UNDEFINE TO_DATE
SET LINE 9999
SET HEAD OFF
SET SERVEROUT ON SIZE 1000000
SET VERIFY OFF
SET FEED OFF
SET TRIMSPOOL ON
PROMPT
PROMPT
ACCEPT ACCOUNT CHAR PROMPT 'Enter the Account Number                                       ==> '
SPOOL §#$!.CVR
SELECT 'ACCEPT FROM_DATE CHAR PROMPT '||CHR(39)||'Enter From Date                       [Default is '||TO_CHAR(last_liq_dt + 1,'DD-MON-YYYY')||'] ==> '||CHR(39)
FROM	ICTB_ACC_PR
WHERE	acc = '&&account'
/
SELECT 'ACCEPT TO_DATE CHAR PROMPT '||CHR(39)||'Enter To Date                         [Default is '||TO_CHAR(today - 1,'DD-MON-YYYY')||'] ==> '||CHR(39)
FROM	STTM_DATES A, STTM_CUST_ACCOUNT B
WHERE	A.branch_code = B.branch_code
AND		B.cust_ac_no = '&&account'
/
SPOOL OFF
CL SCR
PROMPT
PROMPT
PROMPT Enter the Account Number                                       ==> &&ACCOUNT
@§#$!.CVR
ACCEPT L_CONSISTENCY CHAR PROMPT 'Do you want to perform a consistency check? Y/N [Default is N] ==> '
PROMPT
PROMPT
DECLARE
	p_acc		VARCHAR2(20) := '&&account';
	p_prod		VARCHAR2(20);
	p_from_dt	DATE;
	p_to_dt		DATE;
	p_brn		VARCHAR2(3);
	l_ccy			VARCHAR2(3);
	CURSOR	c_ude
	IS
		SELECT	p.brn,p.acc,u.prod,u.ude_id,u.ude_eff_dt,u.amt
		FROM	ICTBS_UDEVALS u,
				ICTBS_ACC_PR p
		WHERE	u.prod = p.prod
		AND		u.cond_type=0
		AND		u.cond_key=p.brn || p.acc
		AND     p.acc = p_acc
		AND     p.brn = p_brn
		AND     p.prod = p_prod
		AND		u.ude_eff_dt <= p_to_dt
	UNION
		SELECT	a.branch_code brn, a.cust_ac_no acc, u.prod, u.ude_id, u.ude_eff_dt, u.amt
		FROM	STTMS_CUST_ACCOUNT a,
				ICTBS_UDEVALS u,
				ICTBS_ACC_PR p,
				ICTMS_PR_INT_ACLASS ap
		WHERE	u.cond_type='1'
		AND		a.account_class || a.ccy = u.cond_key
		AND		a.branch_code = p.brn
		AND		a.cust_ac_no = p.acc
		AND		ap.aclass = a.account_class
		AND		ap.ccy=a.ccy
		AND		ap.sc_only='N'
		AND		ap.product_code=u.prod
		AND		u.prod = p.prod
		AND		u.ude_eff_dt < NVL (p.sc_map_dt,TO_DATE('47121231235959','YYYYMMDDHH24MISS'))
		AND     p.acc = p_acc
		AND     p.brn = p_brn
		AND     p.prod = p_prod
		AND		u.ude_eff_dt <= p_to_dt
		AND		NOT EXISTS (	SELECT	'x'
								FROM	ICTBS_UDEVALS g
								WHERE	g.cond_type=0
								AND		g.prod=p.prod
								AND		g.cond_key=p.brn||p.acc
								AND		g.ude_eff_dt<u.ude_eff_dt)
		ORDER BY 5;
	CURSOR c_bal
	IS
		SELECT	acc, GREATEST(VAL_DT,p_from_dt) dt ,bal
		FROM	VDBAL$ a
		WHERE	acc = p_acc
		AND		val_dt = (	SELECT	MAX(VAL_DT)
							FROM	ACTB_VD_BAL
							WHERE	acc = a.acc
							AND		val_dt <= p_from_dt)
		AND		ccy = l_ccy
	UNION
		SELECT	acc, GREATEST(VAL_DT,p_from_dt) dt ,bal
		FROM	VDBAL$
		WHERE	acc = p_acc
		AND		val_dt BETWEEN p_from_dt AND p_to_dt
		AND		ccy = l_ccy
		ORDER BY 2;
	TYPE rec_ude
	IS RECORD
		(
	    ude_id	VARCHAR2(100),
	    ude_dt	DATE,
	    ude_amt	NUMBER
		);
	TYPE tb_ude
	IS TABLE OF rec_ude INDEX BY BINARY_INTEGER;
	l_tb_ude	tb_ude;
	TYPE rec_bal
	IS RECORD
		(
		bal_dt	DATE,
		bal		NUMBER
		);

	TYPE tb_bal
	IS TABLE OF rec_bal INDEX BY BINARY_INTEGER;
	l_tb_bal	tb_bal;
	TYPE rec_details
	IS RECORD
		(
		rentehrr	NUMBER,
	    from_dt		DATE,
	    to_dt		DATE,
	    days		NUMBER,
	    year		NUMBER,
	    percentage1	NUMBER,
	    percentage2	NUMBER,
	    frm_no		NUMBER,
	    result		NUMBER
		);
	TYPE tb_details
	IS TABLE OF rec_details INDEX BY BINARY_INTEGER;
	l_tb_details	tb_details;
	l_ind			INTEGER;
	l_conv_dt		DATE;
	l_dt			DATE;
	l_next_dt_bal	DATE;
	l_next_dt_ude	DATE;
	l_details_dt	DATE;
	l_bool			BOOLEAN := FALSE;
	l_found_ude		BOOLEAN := FALSE;
	l_found_bal		BOOLEAN := FALSE;
	skip			EXCEPTION;
	l_frm1			BOOLEAN := FALSE;
	l_frm2			BOOLEAN := FALSE;
	l_sum_result	NUMBER := 0;
	l_bal			NUMBER;
	l_lcy_bal		NUMBER;
	l_dr_tur		NUMBER;
	l_cr_tur		NUMBER;
	l_lcy			VARCHAR2(3);
	l_vdbal			NUMBER;
	l_vdbal_lcy		NUMBER;
	l_consistency	VARCHAR2(10);
	l_cons			BOOLEAN := FALSE;
	CURSOR c_acvw IS
		SELECT	DISTINCT value_dt, ac_branch, ac_ccy, ac_no
		FROM	ACVWS_ALL_AC_ENTRIES
		WHERE	ac_no = p_acc
		ORDER BY 1;

BEGIN
	BEGIN
		SELECT	a.last_ccy_conv_date,
				a.branch_code,
				b.prod,
				a.ccy
		INTO	l_conv_dt,
				p_brn,
				p_prod,
				l_ccy
		FROM	STTM_CUST_ACCOUNT a, ICTB_ACC_PR b
		WHERE	a.cust_ac_no = b.acc
		AND		b.acc = p_acc
		AND		b.brn = a.branch_code;
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN
			DBMS_OUTPUT.PUT_LINE('Invalid Account ==> '||p_acc);
			RETURN;	
	END;
	SELECT	branch_lcy
	INTO	l_lcy
	FROM	STTMS_BRANCH
	WHERE	branch_code = p_brn;
	p_from_dt := TO_DATE('&from_date');
	p_to_dt := TO_DATE('&to_date');
	IF p_from_dt IS NULL
	THEN
		SELECT	last_liq_dt + 1
		INTO	p_from_dt
		FROM	ICTB_ACC_PR
		WHERE	acc = p_acc;
	END IF;
	IF p_to_dt IS NULL
	THEN
		SELECT	today - 1
		INTO	p_to_dt
		FROM	STTM_DATES
		WHERE	branch_code = p_brn;
	END IF;
	IF NVL(l_conv_dt,p_from_dt) > p_from_dt
	THEN
		DBMS_OUTPUT.PUT_LINE('Can not calculate interest prior to the CCY Conversion Date '||l_conv_dt);
		RETURN;
	END IF;
	l_tb_ude.DELETE;
	l_ind := 0;
	FOR i IN c_ude
	LOOP
		l_ind := l_ind + 1;
		l_tb_ude(l_ind).ude_id := i.ude_id;
		l_tb_ude(l_ind).ude_dt := i.ude_eff_dt;
		l_tb_ude(l_ind).ude_amt := i.amt;
	END LOOP;
	IF l_tb_ude.COUNT < 1
	THEN
		DBMS_OUTPUT.PUT_LINE('Rate Not Found. Can not proceed');
		RETURN;
	END IF;
	BEGIN
		DELETE VDBAL$ WHERE acc = p_acc;
		SELECT	DECODE(UPPER('&l_consistency'),NULL,'N','N','N','NO','N','Y','Y','YES','Y','N')
		INTO	l_consistency
		FROM	DUAL;
		IF l_consistency = 'Y'
		THEN
			FOR x IN c_acvw
			LOOP
				SELECT	SUM(DECODE(DRCR_IND,'D',-1,1)*LCY_AMOUNT),
						SUM(DECODE(DRCR_IND,'D',-1,1)*FCY_AMOUNT)
				INTO	l_lcy_bal,
						l_bal
				FROM	ACVW_ALL_AC_ENTRIES
				WHERE	AC_NO = X.AC_NO
				AND		VALUE_DT <= X.VALUE_DT;
				SELECT	SUM(DECODE(DRCR_IND,'D',1,0)*NVL(FCY_AMOUNT,LCY_AMOUNT)),
						SUM(DECODE(DRCR_IND,'C',1,0)*NVL(FCY_AMOUNT,LCY_AMOUNT))
				INTO	l_dr_tur,
						l_cr_tur
				FROM	ACVW_ALL_AC_ENTRIES
				WHERE	AC_NO = X.AC_NO
				AND		VALUE_DT = X.VALUE_DT;
				INSERT INTO VDBAL$
					(
					BRN,
					ACC,
					VAL_DT,
					BAL,
					DR_TUR,
					CR_TUR,
					CCY,
					LCY_BAL
					)
				VALUES
					(
					x.ac_branch,
					x.ac_no,
					x.value_dt,
					l_bal,
					l_dr_tur,
					l_cr_tur,
					x.ac_ccy,
					l_lcy_bal
					);
				IF x.ac_ccy = l_lcy
				THEN
					l_bal := l_lcy_bal;
				END IF;
				BEGIN
					SELECT	bal,
							lcy_bal
					INTO	l_vdbal,
							l_vdbal_lcy
					FROM	ACTBS_VD_BAL
					WHERE	acc = x.ac_no
					AND		ccy = x.ac_ccy
					AND		brn = x.ac_branch
					AND		val_dt = x.value_dt;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						DBMS_OUTPUT.PUT_LINE('NO DATA IN ACTB_VD_BAL FOR DATE '||x.value_dt);
				END;
				IF l_bal <> l_vdbal OR l_lcy_bal <> l_vdbal_lcy
				THEN
					IF NOT l_cons
					THEN
						DBMS_OUTPUT.PUT_LINE ('*   Inconsistency exists.');
						DBMS_OUTPUT.PUT_LINE ('*   Date              Balance         Correct     LCY Balance         Correct');
						DBMS_OUTPUT.PUT_LINE ('*                     stored          Balance          stored      LCY Balnce');
						DBMS_OUTPUT.PUT_LINE ('*   -------------------------------------------------------------------------');
						l_cons := TRUE;
					END IF;
					DBMS_OUTPUT.PUT_LINE('* '||LPAD(x.value_dt,11,' ')||' '||LPAD(l_vdbal,15,' ')||' '||LPAD(l_bal,15,' ')||' '||LPAD(l_vdbal_lcy,15,' ')||' '||LPAD(l_lcy_bal,15,' '));
				END IF;
			END LOOP;
			IF NOT l_cons
			THEN
				DBMS_OUTPUT.PUT_LINE('NO INCOSISTENCY');
			ELSE
				DBMS_OUTPUT.PUT_LINE ('*   -------------------------------------------------------------------------');
			END IF;
			UPDATE	VDBAL$
			SET		BAL = LCY_BAL
			WHERE	CCY = l_lcy
			AND		ACC = p_acc;
		ELSE
			INSERT INTO VDBAL$
			SELECT	*
			FROM	ACTBS_VD_BAL
			WHERE	ACC = p_acc;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Consistency Check Failed '||SQLERRM);
			RETURN;
	END;
	l_tb_bal.DELETE;
	l_ind := 0;
	FOR i IN c_bal
	LOOP
		l_ind := l_ind + 1;
		l_tb_bal(l_ind).bal_dt := i.dt;
		l_tb_bal(l_ind).bal := i.bal;
	END LOOP;
	IF l_tb_bal.COUNT < 1
	THEN
		DBMS_OUTPUT.PUT_LINE('Balance Not Found. 0 Interest !');
		RETURN;
	END IF;
	l_tb_details.DELETE;
	l_dt := p_from_dt;
	l_details_dt := p_from_dt;
	l_tb_details(1).from_dt := p_from_dt;
	l_ind := 1;
	WHILE l_dt <= p_to_dt
	LOOP
		l_found_ude := FALSE;
		l_found_bal := FALSE;
		FOR a IN l_tb_bal.FIRST .. l_tb_bal.LAST
		LOOP
			IF l_tb_bal(a).bal_dt >= l_dt
			THEN
				l_next_dt_bal := l_tb_bal(a).bal_dt;
				l_found_bal := TRUE;
				EXIT;
			END IF;
		END LOOP;
		FOR a IN l_tb_ude.FIRST .. l_tb_ude.LAST
		LOOP
			IF l_tb_ude(a).ude_dt >= l_dt
			THEN
				l_next_dt_ude := l_tb_ude(a).ude_dt;
				l_found_ude := TRUE;
				EXIT;
			END IF;
		END LOOP;
		IF l_found_ude = TRUE AND l_found_bal = TRUE
		THEN
			SELECT	LEAST(l_next_dt_bal,l_next_dt_ude)
			INTO	l_details_dt
			FROM	DUAL;
		ELSIF l_found_ude = TRUE AND l_found_bal = FALSE
		THEN
			l_details_dt := l_next_dt_ude;
		ELSIF l_found_ude = FALSE AND l_found_bal = TRUE
		THEN
			l_details_dt := l_next_dt_bal;
		END IF;
		IF	l_tb_details.COUNT = 0
		THEN
			l_ind := 1;
			l_tb_details(l_ind).from_dt := l_details_dt;
		ELSE
			l_bool := FALSE;
			FOR b IN l_tb_details.FIRST .. l_tb_details.LAST
			LOOP
				IF l_tb_details(b).from_dt = l_details_dt
				THEN
					l_bool := TRUE;
					EXIT;
				END IF;
			END LOOP;
			IF NOT l_bool
			THEN
				l_ind := l_ind + 1;
				l_tb_details(l_ind).from_dt := l_details_dt;
			END IF;
		END IF;
		l_dt := l_dt + 1;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(CHR(10)||'------------------------------------------------------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE(' ACCOUNT       '||p_acc);
	DBMS_OUTPUT.PUT_LINE(' FROM DATE     '||p_from_dt);
	DBMS_OUTPUT.PUT_LINE(' TO DATE       '||p_to_dt);
	DBMS_OUTPUT.PUT_LINE(CHR(10)||'------------------------------------------------------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE('FROM DATE      TO DATE         DAYS    RENTEHRR PERCENTAGE1 PERCENTAGE2  YEAR FORMULA INTEREST   TOTAL');
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');
	FOR i IN l_tb_details.FIRST .. l_tb_details.LAST
	LOOP
		IF i <> l_tb_details.COUNT
		THEN
			l_tb_details(i).to_dt := l_tb_details(i+1).from_dt - 1;
		ELSE
			l_tb_details(i).to_dt := p_to_dt;
		END IF;
		l_tb_details(i).days := l_tb_details(i).to_dt - l_tb_details(i).from_dt + 1;
		l_tb_details(i).rentehrr := 0;
		FOR a IN l_tb_bal.FIRST .. l_tb_bal.LAST
		LOOP
			IF l_tb_bal(a).bal_dt > l_tb_details(i).from_dt
			THEN
				EXIT;
			END IF;
			l_tb_details(i).rentehrr := l_tb_bal(a).bal;
		END LOOP;
		l_tb_details(i).percentage1 := 0;
		FOR a IN l_tb_ude.FIRST .. l_tb_ude.LAST
		LOOP
			BEGIN
				IF l_tb_ude(a).ude_id <> 'PERCENTAGE1'
				THEN
					RAISE skip;
				END IF;
				IF l_tb_ude(a).ude_dt > l_tb_details(i).from_dt
				THEN
					EXIT;
				END IF;
				l_tb_details(i).percentage1 := l_tb_ude(a).ude_amt;
			EXCEPTION
				WHEN SKIP
				THEN
					NULL;
			END;
		END LOOP;
		l_tb_details(i).percentage2 := 0;
		FOR a IN l_tb_ude.FIRST .. l_tb_ude.LAST
		LOOP
			BEGIN
				IF l_tb_ude(a).ude_id <> 'PERCENTAGE2'
				THEN
					RAISE skip;
				END IF;
				IF l_tb_ude(a).ude_dt > l_tb_details(i).from_dt
				THEN
					EXIT;
				END IF;
				l_tb_details(i).percentage2 := l_tb_ude(a).ude_amt;
			EXCEPTION
				WHEN SKIP
				THEN
					NULL;
			END;
		END LOOP;
		IF (TO_CHAR(LAST_DAY(TO_DATE(TO_CHAR(l_tb_details(i).from_dt,'YYYY') || '0201','YYYYMMDD')),'DD') = 29)
		THEN
			l_tb_details(i).year := 366;
		ELSE
			l_tb_details(i).year := 365;
		END IF;
		l_tb_details(i).result := 0;
		IF l_tb_details(i).rentehrr <= 1000000
		THEN
			l_frm1 := TRUE;
			l_tb_details(i).frm_no := 1;
			l_tb_details(i).result := l_tb_details(i).rentehrr*l_tb_details(i).percentage1*(l_tb_details(i).days/(l_tb_details(i).year*100));
		ELSIF l_tb_details(i).rentehrr > 1000000
		THEN
			l_frm2 := TRUE;
			l_tb_details(i).frm_no := 2;
			l_tb_details(i).result := (1000000*l_tb_details(i).percentage1*(l_tb_details(i).days/(l_tb_details(i).year*100)))+((l_tb_details(i).rentehrr-1000000)*l_tb_details(i).percentage2*(l_tb_details(i).days/(l_tb_details(i).year*100)));
		END IF;
		l_sum_result := l_sum_result + l_tb_details(i).result;
		DBMS_OUTPUT.PUT_LINE(	RPAD(TO_CHAR(l_tb_details(i).from_dt,'DD-MON-YYYY'),15,' ')	-- FROM Date
							 || RPAD(TO_CHAR(l_tb_details(i).to_dt,'DD-MON-YYYY'),15,' ')	-- TO Date
							 || LPAD(TO_CHAR(l_tb_details(i).days),5,' ')					-- DAYS
							 || LPAD(TO_CHAR(ROUND(l_tb_details(i).rentehrr,2)),12,' ')		-- RENTEHRR
							 || LPAD(TO_CHAR(ROUND(l_tb_details(i).percentage1,2)),12,' ')	-- PERCENTAGE1
							 || LPAD(TO_CHAR(ROUND(l_tb_details(i).percentage2,2)),12,' ')	-- PERCENTAGE2
							 || LPAD(TO_CHAR(l_tb_details(i).year),6,' ')					-- YEAR
							 || LPAD(TO_CHAR(l_tb_details(i).frm_no),4,' ')					-- FORMULA No.
							 || LPAD(TO_CHAR(ROUND(l_tb_details(i).result,2)),10)			-- RESULT
							 || LPAD(TO_CHAR(ROUND(l_sum_result,2)),10)						-- RUNNING TOTAL
							);
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------'||CHR(10));
	IF l_frm1 THEN
		DBMS_OUTPUT.PUT_LINE('** FORMULA 1 **');
		DBMS_OUTPUT.PUT_LINE('   CASE   #  RENTEHRR<=1000000');
		DBMS_OUTPUT.PUT_LINE('   RESULT #  RENTEHRR*PERCENTAGE1*(DAYS/(YEAR*100))');
	END IF;
	IF l_frm2 THEN
		DBMS_OUTPUT.PUT_LINE('** FORMULA 2 **');
		DBMS_OUTPUT.PUT_LINE('   CASE   #  RENTEHRR>1000000');
		DBMS_OUTPUT.PUT_LINE('   RESULT #  (1000000*PERCENTAGE1*(DAYS/(YEAR*100)))+((RENTEHRR-1000000)*PERCENTAGE2*(DAYS/(YEAR*100)))');
	END IF;
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('GOOGLY '||SQLERRM);
END;
/
COMMIT
/
SET VERIFY ON
SET FEED ON
UNDEFINE ACCOUNT
UNDEFINE FROM_DATE
UNDEFINE TO_DATE
SET HEAD ON
PROMPT
PROMPT

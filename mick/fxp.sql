DECLARE
	p_dt		DATE := '&date';
	l_dt		DATE;
	l_ccy		CYTM_CCY_DEFN.ccy_code%TYPE;
	l_rec		BOTB_FX_TRADE_PROFIT%ROWTYPE;
	l_rate		NUMBER;
	l_rate_flg	NUMBER;
	l_err		VARCHAR2(1000);	
	l_lcy_amt	NUMBER;

	CURSOR	c_ccy
	IS	SELECT	ccy_code
		FROM	CYTM_CCY_DEFN
		WHERE	record_stat = 'O';

BEGIN
	global.pr_init ('400','FXTRADE');

	SELECT	TRUNC(p_dt)
	INTO	l_dt
	FROM	DUAL;

	DELETE	BOTB_FX_TRADE_PROFIT
	WHERE	today = l_dt;

	l_rec.today := l_dt;

	FOR x IN c_ccy
	LOOP

		l_ccy := x.ccy_code;
		l_rec.ccy := l_ccy;

		SELECT	NVL(SUM(bot_amt),0)
		INTO	l_rec.today_buy
		FROM	botb_fx
		WHERE	trn_dt = l_dt
		AND	bot_ccy = l_ccy;

		SELECT	NVL(SUM(sold_amt),0)
		INTO	l_rec.today_sell
		FROM	botb_fx
		WHERE	trn_dt = l_dt
		AND	sold_ccy = l_ccy;

		l_rec.today_net := l_rec.today_buy - l_rec.today_sell;

		IF NOT CYPKS.fn_getrate
			(
			GLOBAL.current_branch,
			l_ccy,
			GLOBAL.lcy,
			l_dt,
			GLOBAL.application_date,
			l_rate,
			l_rate_flg,
			l_err
			)
		THEN
			DBMS_OUTPUT.put_line ('Error in getting rate '||l_err);
			l_rate := '';
		END IF;

		l_rec.today_rate := l_rate;

		IF NOT CYPKS.FN_AMT1_TO_AMT2
			(
			l_ccy,
			GLOBAL.lcy,
			l_rec.today_net,
			l_rate,
			'Y',
			l_lcy_amt,
			l_err
			)
		THEN
			DBMS_OUTPUT.put_line ('Error in converting amount '||l_err);			
			l_lcy_amt := 0;
		END IF;

		l_rec.today_profit := l_lcy_amt;

		INSERT INTO BOTB_FX_TRADE_PROFIT
			(
			today,
			ccy,
			opening_buy,
			opening_sell,
			opening_net,
			opening_profit,
			today_buy,
			today_sell,
			today_rate,
			today_net,
			today_profit
			)
		VALUES
			(
			l_rec.today,
			l_rec.ccy,
			l_rec.opening_buy,
			l_rec.opening_sell,
			l_rec.opening_net,
			l_rec.opening_profit,
			l_rec.today_buy,
			l_rec.today_sell,
			l_rec.today_rate,
			l_rec.today_net,
			l_rec.today_profit
			);
	END LOOP;
END;
/


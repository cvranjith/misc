DECLARE
F DATE := TO_DATE('&FROM_DT','DD-MON-RRRR');
T DATE := TO_DATE('&TO_DT','DD-MON-RRRR');
M NUMBER := TO_NUMBER('&SPLIT');
n number;
BEGIN

icpkss_calc.g_ictb_acc_pr.first_calc_dt := f;
icpkss_calc.g_ictb_acc_pr.next_liq_dt := t;

n := subseq_days(m);

DBMS_OUTPUT.PUT_LINE('SUBSEQ DAYS IS '||N);
END;
/

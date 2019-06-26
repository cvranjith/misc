
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99

SPOOL /tmp/CCY_DETAILS.SPL

PROMPT CYTM_CCY_DEFN 

SELECT * FROM CYTM_CCY_DEFN
/

PROMPT CYTM_CCY_PAIR_DEFN 

SELECT * FROM CYTM_CCY_PAIR_DEFN WHERE CCY1 = 'SGD' OR CCY2 = 'NOK'
order by ccy1
/

PROMPT CYTB_CCY_PAIR 

SELECT * FROM CYTB_CCY_PAIR WHERE CCY1 = 'SGD' OR CCY2 = 'NOK'
order by ccy1
/

PROMPT CYTM_DERIVED_RATES 

SELECT * FROM CYTM_DERIVED_RATES WHERE CCY1 = 'SGD' OR CCY2 = 'NOK'
order by ccy1
/

PROMPT CYTM_RATES 

SELECT * FROM CYTM_RATES WHERE CCY1 = 'SGD' OR CCY2 = 'NOK'
order by ccy1
/

PROMPT CYTM_RATES_MASTER 

SELECT * FROM CYTM_RATES_MASTER WHERE CCY1 = 'SGD' OR CCY2 = 'NOK'
order by ccy1
/

PROMPT CYTB_RATES_HISTORY 

SELECT * FROM CYTB_RATES_HISTORY WHERE CCY1 = 'SGD' OR CCY2 = 'NOK'
order by ccy1
/

select * from sttb_record_log where table_name like '%CYTM%CCY%'
/

select * from sttb_field_log where table_name like '%CYTM%CCY%'
/

select * from sttb_field_log_hist where table_name like '%CYTM%CCY%'
/

select * from sttb_record_log_hist where table_name like '%CYTM%CCY%'
/


SPOOL OFF


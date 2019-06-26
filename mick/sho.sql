set termout off feed off pages 0 verify off serverout on size 1000000
define _editor=vi
spo tmp.tmp
select 'set sqlpro "'||host_name||' : '||user||' @ '||instance_name||'>"'
from    v$instance 
where	instance_number = userenv('instance')
/
spo off
@tmp.tmp
set termout on

pro 
pro ==================================
pro
select
'  USER       is   "'||USER||'"
  INSTANCE   is   "'||INSTANCE_NAME ||'"
  HOST       is   "'|| HOST_NAME||'"
  SID        is   "'||SID||'"
  TERMINAL   is   "'||USERENV('TERMINAL')||'"'
from v$instance ,v$session 
where	audsid = userenv('SESSIONID')
and	instance_number = userenv('INSTANCE')
/
pro ==================================
pro
set feed on pages 100 verify on colsep " | "
cl buff

set time on timing on line 9999

col account_number form a16
col trn_ref_no form a16
col cust_ac_no form a16
col gl_code form a16
col ccy form a3
col lcy form a3
col ac_no form a16
col remarks form a30
col amount_tag form a15
col amt_tag form a15
col trn_Code form a3
col branch_Code form a3
col brn form a3
col ac_branch form a3
col branch form a3
col OWNER form a10
col CONSTRAINT_NAME form a30
col TABLE_NAME form a30
col COLUMN_NAME form a30
col INDEX_NAME form a30
col COLUMN_NAME form a30
col checker_id form a12
col maker_id form a12
col user_id form a12
col product_code form a4
col prod form a4
col prd form a4
col field_name form a30
col field_type form a1
col entity_query form a60 wrap
col param_name form a10
col param_val form a30

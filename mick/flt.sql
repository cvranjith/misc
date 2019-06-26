delete CFTM_FLOAT_RATE_DETAIL where rate_code = '&1' and ccy_code = '&4' and effective_date = to_date('&2','DD/MM/YYYY');

declare
d date := to_date('&2','DD/MM/YYYY');
r number := '&3';
begin
for i in
(
select * from CFTM_FLOAT_RATE_DETAIL e
where rate_code = '&1'
and ccy_code = '&4'
and effective_date = (select max(d.effective_date) from CFTM_FLOAT_RATE_DETAIL d where d.rate_Code = e.rate_Code and d.ccy_code = e.ccy_code)
and borrow_lend_ind = 'M'
)
loop
i.effective_date := d;
i.int_rate := r;
insert into CFTM_FLOAT_RATE_DETAIL values i;
end loop;
end;
/

insert into CFTM_FLOAT_RATE_MASTER a
select distinct b.rate_code,b.ccy_code,b.amount_slab,b.effective_date,'A',
0,'31-DEC-2099',b.branch_code,b.borrow_lend_ind
from CFTM_FLOAT_RATE_DETAIL b
where not exists (select 1 from CFTM_FLOAT_RATE_MASTER c where c.rate_code = b.rate_code
and c.ccy_code = b.ccy_code
and c.amount_slab = b.amount_slab
and c.effective_date = b.effective_date
and c.branch_code  = b.branch_code
and c.borrow_lend_ind = b.borrow_lend_ind
)
/


insert into CFTM_FLOAT_RATE_MASTER
select RATE_CODE,CCY_CODE,AMOUNT_SLAB,EFFECTIVE_DATE,RATE_RECORD_STATUS,PREV_AMOUNT_SLAB
,NEXT_EFFECTIVE_DATE,BRANCH_CODE,'L'
from CFTM_FLOAT_RATE_MASTER a
where BORROW_LEND_IND = 'M'
and not exists (select 1 from CFTM_FLOAT_RATE_MASTER b
where a.RATE_CODE = b.rate_code
and a.ccy_Code = b.ccy_code
and a.amount_slab = b.amount_slab
and a.effective_date = b.effective_date
and a.BRANCH_CODE = b.BRANCH_CODE
and b.BORROW_LEND_IND = 'L'
)
/

insert into CFTM_FLOAT_RATE_DETAIL
select RATE_CODE,CCY_CODE,AMOUNT_SLAB,EFFECTIVE_DATE,BRANCH_CODE,'L',
TENOR_FROM,99999,INT_RATE
from CFTM_FLOAT_RATE_DETAIL a
where BORROW_LEND_IND = 'M'
and TENOR_TO = 0
and not exists (select 1 from
CFTM_FLOAT_RATE_DETAIL b
where b.RATE_CODE = a.RATE_CODE
and b.CCY_CODE = a.CCY_CODE
and b.AMOUNT_SLAB= a.AMOUNT_SLAB
and b.EFFECTIVE_DATE = a.EFFECTIVE_DATE
and b.BRANCH_CODE = a.BRANCH_CODE
and b.BORROW_LEND_IND = 'L'
and b.TENOR_TO =99999
)
/

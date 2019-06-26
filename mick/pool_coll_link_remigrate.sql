
declare
x getm_pool_coll_linkages%rowtype;
n number := 0;
begin
delete getm_pool_coll_linkages;
for i in (select * from lmtm_pool_collateral_linkages)
loop
x := null;
n := n+1;
x.id := n;
select  id
into    x.liab_id
from    getm_liab
where   liab_no = i.liab_id;
select  id
into    x.pool_id
from    getm_pool
where   pool_code = i.pool_code
and     liab_id = x.liab_id;
x.order_no := i.order_no;
x.type := i.type;
x.BRANCH_CODE := i.BRANCH_CODE;
if i.type = 'C'
then
    select  id
    into    x.collateral_id
    from    getm_collat
    where   collateral_code = i.collateral_code;
else
    select  coll_id
    into    x.collateral_id
    from    getm_collat_cont_contrib
    where   contract_ref_no = i.collateral_code;
end if;
x.collateral_currency := i.collateral_currency;
x.collateral_amount := i.collateral_amount;
x.linked_amount := i.linked_amount;
x.linked_amount_pool_ccy := i.linked_amount_pool_ccy;
x.auto_delink := i.auto_delink;
x.utilization := i.utilization;
x.lien_number := i.lien_number;
x.linked_percent_number := i.linked_percent_number;
x.diff_amount := i.diff_amount;
x.auth_stat := 'A';
x.mod_no := 1;
x.user_refno := i.collateral_code;
insert into getm_pool_coll_linkages values x;
end loop;
end;
/




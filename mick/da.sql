declare
procedure pr(p_crn in varchar2)
is
l_crn                       varchar2(1000) := p_crn;
l_cs_rec                    cstbs_contract%rowtype;
l_ld_rec                    ldtbs_contract_master%rowtype;
l_datms_prod_ccy_pref       datms_prod_ccy_pref%rowtype;
l_err_code                  varchar2(1000);
l_params                    varchar2(1000);
l_int_rate                  number;
n                           number;
l_ad                        cstbs_amount_due%rowtype;
begin
select  count(1)
into    n
from    datbs_contract_irr
where   contract_ref_no = l_crn;
if n > 0
then
    return;
end if;
select  *
into    l_cs_rec
from    cstbs_contract
where   contract_ref_no = l_crn;
if l_cs_rec.module_code != 'LD' or l_cs_rec.product_type != 'L'
then
    raise_application_error(-20001,'Invalid Product Type');
end if;
for i in
    (
    select  *
    from    ldtbs_contract_master
    where   contract_ref_no = l_crn
    order by version_no desc
    )
loop
    l_ld_rec := i;
    exit;
end loop;
for i in
    (
    select  *
    from    datms_prod_ccy_pref
    where   product_code  = l_cs_rec.product_code
    and     ccy_code  in (l_cs_rec.contract_ccy,'ALL')
    order by decode(ccy_code,'ALL',2,1)
    )
loop
    l_datms_prod_ccy_pref := i;
    exit;
end loop;
select  rate
into    l_int_rate
from    ldvws_contract_summary
where   contract_ref_no = l_crn;
select  count(1)
into    n
from    cstb_amount_due
where   contract_ref_no = l_crn
and     component = 'PRINCIPAL'
--and     inflow_outflow = 'O'
and     due_date  = l_ld_rec.value_date;
if n = 0
then
l_ad.CONTRACT_REF_NO	:= l_crn;
l_ad.COMPONENT	:= 'PRINCIPAL';
l_ad.DUE_DATE	:= l_ld_rec.value_date;
l_ad.AMOUNT_DUE	:= l_ld_rec.amount;
l_ad.CURRENCY_AMT_DUE	:= l_ld_rec.CURRENCY;
l_ad.COUNTERPARTY	:= l_cs_rec.COUNTERPARTY;
l_ad.AMOUNT_SETTLED	:= l_ld_rec.amount;
l_ad.INFLOW_OUTFLOW	:= 'O';
l_ad.ADJUSTED_AMOUNT	:= 0;
l_ad.MSG_EVENT_SEQ_NO	:= -1;
l_ad.SCH_PICKED_FOR_LIQ	:= 'Y';
l_ad.COMPONENT_TYPE	:= 'p';
l_ad.FIXED_AMOUNT_FLAG	:= 'N';
insert into cstbs_amount_due values l_ad;
end if;
global.pr_Init(l_cs_rec.branch,'SYSTEM');
IF NOT Dapkss_Services_0.Fn_Populate_Irr_Details
        (
        l_cs_rec.branch,
        l_cs_rec.module_code,
        l_cs_rec.contract_ref_no,
        l_cs_rec.contract_ccy,
        l_ld_rec.value_date,
        l_ld_rec.value_date,
        l_ld_rec.payment_method,
        l_int_rate,
        NULL,
        l_datms_prod_ccy_pref.denom_dcount_method,
        l_datms_prod_ccy_pref.numer_dcount_method,
        l_err_code,
        l_params
        )
THEN
        raise_application_error(-20001,'e '||l_err_code || ' '||l_crn);
END IF;
end;
begin
pr('ACULTBF090630008');return;
for i in (select contract_ref_no from cstb_contract where module_Code = 'LD' and product_type = 'L' and contract_status = 'A')
loop
pr(i.contract_ref_no);
end loop;
end;
/

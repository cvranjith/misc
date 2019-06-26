declare
l_per varchar2(100) := 'M01';
l_brn varchar2(100) := '010';
l_fin varchar2(100) := 'FY2009';
begin
global.pr_init(l_brn,'SYSTEM');
delete  gltb_gl_bal
where   branch_code = l_brn
and     period_code = l_per
and     fin_year = l_fin;
insert into gltb_gl_bal(branch_Code,gl_code,ccy_code,fin_year,period_code,gaap_indicator,internal_gl_type)
select distinct l_brn,
                gl_code,
                ac_ccy,
                l_fin,
                l_per,
                'ALL',
                'N'
from            rptb_gl_bal
where           brn = l_brn;
update  gltb_gl_bal
set     dr_bal=0,
        cr_bal=0,
        dr_bal_lcy=0,
        cr_bal_lcy=0,
        dr_mov=0 ,
        cr_mov=0,
        dr_mov_lcy=0,
        cr_mov_lcy=0,
        uncollected=0,
        open_dr_bal=0,
        open_cr_bal=0,
        open_dr_bal_lcy=0,
        open_cr_bal_lcy=0,
        open_dr_mov=0,
        open_cr_mov=0,
        open_dr_mov_lcy=0,
        open_cr_mov_lcy=0,
        dr_mov_old=0,
        cr_mov_old=0,
        dr_mov_lcy_old=0,
        cr_mov_lcy_old=0
where   branch_code = l_brn
and     period_code = l_per
and     fin_year = l_fin;
update  gltb_gl_bal
set     dr_bal = 0,
        cr_bal=0,
        dr_bal_lcy=0,
        cr_bal_lcy=1
where   branch_code = l_brn
and     rownum = 1
and     period_code = l_per
and     fin_year = l_fin;
for i in
    (
    select  gl_code,
            rowid rid
    from    gltb_gl_bal
    where   branch_code = l_brn
    and     period_code = l_per
    and     fin_year = l_fin
    )
loop
    for j in
        (
        select  parent_gl,
                leaf,
                category
        from    gltm_glmaster
        where   gl_code = i.gl_code
        )
    loop
        update  gltb_gl_bal
        set     parent_gl = j.parent_gl,
                leaf = j.leaf,
                category=j.category
        where   rowid = i.rid;
    end loop;
end loop;
if not glpkss_rebuild.fn_glupd(global.current_branch,global.lcy,'Y','Y','N','N','Y')
then
    null;
end if;
end;
/

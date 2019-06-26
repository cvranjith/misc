delete from smtb_user_role WHERE role_id in('MAINTENANCE','ALLROLES') and user_id='SYSTEM';
insert into smtb_user_role 
(select 'MAINTENANCE','SYSTEM','A',branch_code from sttm_branch
union  
select 'ALLROLES','SYSTEM','A',branch_code from sttm_branch);
commit;


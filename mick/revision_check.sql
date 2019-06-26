
select * From CLTB_REVN_SCHEDULES a
where --trunc(schedule_due_date) < trunc(sysdate)
--and account_number = 'ACULOOL120840034'
--and
applied_flag is null
and account_number in (select x.account_number from cltb_account_master x where account_status = 'A')
and account_number in 
(
select x.account_number from cltb_account_events_diary x
where x.account_number = a.account_number
and x.event_code = 'REVN'
and x.component_name = a.component_name
and x.execution_date = a.schedule_Due_date
and x.execution_status = 'P'
)
/


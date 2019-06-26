begin
for i in (select * from cstb_contract_event_log where contract_Ref_no = 'ACULABF090410004' and event_seq_no = 1)
loop
i.contract_Ref_no := 'ACULABF090420007';i.auth_status := 'U';i.checker_id := null;i.checker_dt_stamp := null;i.maker_id:= 'IFLEX';
insert into cstb_contract_event_log values i;
insert into ldtb_contract_control values (i.contract_Ref_no,'LDINIT',i.maker_id,sysdate);
end loop;
end;
/

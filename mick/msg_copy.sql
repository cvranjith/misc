begin
for i in
        (
        select * from mstb_dly_msg_in
        where dcn = '090910107'
        )
        loop
        i.dcn := 'Test2';
        i.status := 'U';
       i.process_status := 'U';
      i.generated_ref_no := null;
      i.reference_no := null;
      insert into mstb_dly_msg_in values i;
      end loop;
end;
/

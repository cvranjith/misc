
declare
a boolean;
e varchar2(1000);
p varchar2(1000);
begin
for i in
(select * from udtm_fields)
loop
  a:=udpks_server.fn_create(i.field_name,i.alt_field_name,i.field_type,i.usage_allowed,
                                                                i.drv_rule_type,i.drv_rule,i.val_rule_type,
                                                                i.val_rule,i.default_value,e,p);
end loop;
end;
/


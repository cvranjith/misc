
CREATE TABLE CSTB_AUDIT_DDL (
  dt timestamp,
  OSUSER varchar2(255),
  CURRENT_USER varchar2(255),
  HOST varchar2(255),
  TERMINAL varchar2(255),
  owner varchar2(30),
  type varchar2(30),
  name varchar2(30),
  sysevent varchar2(30));

create or replace procedure pr_audit (p_curr_user in varchar2, p_ora_dict_obj_owner in varchar2,
      p_ora_dict_obj_type in varchar2,
      p_ora_dict_obj_name in varchar2,
      p_ora_sysevent in varchar2)
is
begin
  if (p_ora_sysevent='TRUNCATE')
  then
    null;
  else
    insert into CSTB_AUDIT_DDL(dt, osuser,current_user,host,terminal,owner,type,name,sysevent)
    values(
      systimestamp,
      sys_context('USERENV','OS_USER') ,
      p_curr_user ,
      sys_context('USERENV','HOST') ,
      sys_context('USERENV','TERMINAL') ,
      p_ora_dict_obj_owner,
      p_ora_dict_obj_type,
      p_ora_dict_obj_name,
      p_ora_sysevent
    );
  end if;
end;
/

grant execute on pr_audit to PUBLIC;
grant select,insert,delete,update on CSTB_AUDIT_DDL to RESTUTIL;


create or replace trigger audit_ddl_trg after ddl on schema
begin
  patchdba.pr_audit(sys_context('USERENV','CURRENT_USER'), ora_dict_obj_owner,
  ora_dict_obj_type,
  ora_dict_obj_name,
  ora_sysevent);
end;
/

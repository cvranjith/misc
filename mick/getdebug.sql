@storeset
--set serverout on size 1000000 
set termout on trimspo on verify off feed off
undef fil
accept fil char prompt 'file = '
set termout off

declare
n number;
begin
select count(1) into n from user_objects where object_name = 'TMP_DBG$_A_B_1789';
if n = 0
then
execute_immediate('create table TMP_DBG$_A_B_1789 (n number,x varchar2(4000)');
end if;
end;
/

declare
  x varchar2(100) := '&FIL';
  f utl_file.file_type;
  l varchar2(4500);
  a number :=0;
begin
  IF X IS NULL THEN X:= GLOBAL.USER_ID||GLOBAL.CURRENT_BRANCH;END IF;
  if substr(x,-4) != '.TXT'
  then
    x := x||'.TXT';
  end if;
  delete TMP_DBG$_A_B_1789;
  f := utl_file.fopen(global.work_area,x,'r');
  loop
    utl_file.get_line(f,l);
    --dbms_output.put_line(l);
    a := a+1;
    insert into TMP_DBG$_A_B_1789 (n,x) values (a,l);
  end loop;
  COMMIT;
exception

  when no_data_found
  then

    if utl_file.is_open(f)
    then
      utl_file.fclose(f);
    end if;

  when others
  then

    dbms_output.put_line('==================='||sqlerrm);
    if utl_file.is_open(f)
    then
      utl_file.fclose(f);
    end if;
end;
/


set line 9999 trimspo on pages 0
spo tmp.tmp
select x from TMP_DBG$_A_B_1789 order by n;
spo off

ed tmp.tmp
@restoreset

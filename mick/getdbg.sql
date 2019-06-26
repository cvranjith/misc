@storeset
set serverout on size 1000000 termout on trimspo on verify off feed off
undef fil
accept fil char prompt 'file = '
set termout off
spo tmp.tmp

declare
  x varchar2(100) := '&FIL';
  f utl_file.file_type;
  l varchar2(4500);
begin
  IF X IS NULL THEN X:= GLOBAL.USER_ID||GLOBAL.CURRENT_BRANCH;END IF;
  if substr(x,-4) != '.TXT'
  then
    x := x||'.TXT';
  end if;

  f := utl_file.fopen(global.work_area,x,'r');
  loop
    utl_file.get_line(f,l);
    dbms_output.put_line(l);
  end loop;

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

spo off
ed tmp.tmp
@restoreset


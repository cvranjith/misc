ldir=`sqlplus -S $FLXSCHEMA <<EOF
set serverout on size 1000000 pages 0 line 9999 feed off 
begin
for i in (select directory_path d from all_directories where directory_name = '$1') loop
dbms_output.put_line(i.d);
end loop;
end;
/
exit;
EOF`
cd $ldir

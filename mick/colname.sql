declare
    l_desc_tab   dbms_sql.desc_tab;
    l_cols       number;
    l_cursor     number;
    l_query      long;
begin
    l_cursor := dbms_sql.open_cursor;
    dbms_sql.parse( l_cursor, '&qry', dbms_sql.native );
    dbms_sql.describe_columns( l_cursor, l_cols, l_desc_tab );
    if l_desc_tab.count > 0
    then
       for i in l_desc_tab.first .. l_desc_tab.last
       loop
           dbms_output.put_line(l_desc_tab(i).col_name);
       end loop;
    end if;
end;
/

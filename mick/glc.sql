
@storeset
set serverout on size 1000000 trimspo on pages 0 line 9999 verify off feed off termout on
declare
l_gl    varchar2(11) := '&1';
n       varchar2(1) := '1';
function q(p_txt in varchar2) return varchar2
is
begin
return chr(39)||p_txt||chr(39);
end;
procedure p(p_query in varchar2)
is
l_query         varchar2(1000) := p_query;
l_tab           varchar2(1000);
l_desc_tab      dbms_sql.desc_tab;
l_cols          number;
l_cur           integer default dbms_sql.open_cursor;
l_val           varchar2(2000);
l_status        integer;
l_col_cnt       number := 0;
l_ins1          varchar2(32000);
l_ins2          varchar2(32000);
l_tmp           varchar2(1000);
begin
    if upper(ltrim(l_query)) not like 'SELECT%'
    then
       l_query := 'select * from '||l_query;
    end if;
    if l_tab is null
    then
        l_tab := upper(l_query);
        l_tab := replace(l_tab,chr(10),' ')||' ';
        l_tab := substr(l_tab,instr(upper(l_tab),'FROM')+5);
        l_tab := ltrim(l_tab);
        l_tab := substr(l_tab,1,instr(l_tab,' ')-1);
    end if;
    dbms_sql.parse(  l_cur,  l_query, dbms_sql.native );
    dbms_sql.describe_columns( l_cur, l_cols, l_desc_tab );
    if l_desc_tab.count > 0
    then
        l_ins1 := 'insert into '||l_tab||' (';
        l_tmp  := l_ins1;
        for i in l_desc_tab.first .. l_desc_tab.last
        loop
            if length(l_tmp) > 100
            then
                l_tmp := null;
                l_ins1 := l_ins1||chr(10);
            end if;
            l_ins1 := l_ins1||l_desc_tab(i).col_name||',';
            l_tmp := l_tmp||l_desc_tab(i).col_name||',';
        end loop;
        l_ins1 := rtrim(l_ins1,',')||') values'||chr(10)||'(';
    end if;
    for i in 1 .. 255 loop
        begin
            dbms_sql.define_column( l_cur, i,
                                    l_val, 2000 );
            l_col_cnt := i;
        exception
            when others then
                if ( sqlcode = -1007 ) then exit;
                else
                    raise;
                end if;
        end;
    end loop;

    dbms_sql.define_column( l_cur, 1, l_val,
                            2000 );
    l_status := dbms_sql.execute(l_cur);
    loop
        exit when ( dbms_sql.fetch_rows(l_cur) <= 0 );
        l_ins2 := null;
        l_tmp := null;
        for i in 1 .. l_col_cnt loop
            dbms_sql.column_value( l_cur, i,
                                   l_val );
            if l_desc_tab(i).col_type = 12
            then
                l_val := 'to_date('||chr(39)||to_char(to_date(l_val),'YYYYMMDDHH24MISS')||chr(39)||','||chr(39)||'YYYYMMDDHH24MISS'||chr(39)||')';
            else
                l_val := chr(39)||replace(l_val,chr(39),chr(39)||chr(39))||chr(39);
            end if;
            if length(l_tmp) > 100
            then
                l_ins2 := l_ins2||chr(10);
                --dbms_output.put_line(l_tmp);
                l_tmp := null;
            end if;
            l_ins2 := l_ins2||l_val||',';
            l_tmp := l_tmp||l_val||',';
        end loop;
        l_ins2 := l_ins1||rtrim(l_ins2,',')||');'||chr(10);

        loop
                dbms_output.put_line(substr(l_ins2,1,instr(l_ins2,chr(10),1,1)-1));
                l_ins2 := substr(l_ins2,instr(l_ins2,chr(10),1,1)+1);
                if l_ins2 is null then exit; end if;
        end loop;
    end loop;
    dbms_sql.close_cursor(l_cur);
end;
begin
p('gltm_glmaster where gl_code = '||q(l_gl));
p('sttb_account where ac_gl_no = '||q(l_gl));
p('gltm_pos_detail where gl_code = '||q(l_gl));
for i in (select field_value from csvws_function_udefvals where field_name = 'CO_FOR_CAPITAL_MARKET' and rec_key = l_gl||'~')
loop
if global.head_office = '868' then n := '2'; end if;
dbms_output.put_line('insert into cstm_function_userdef_fields (function_id,rec_key) values ('||q('GLDCHACT')||','||q(l_gl||'~')||');');
dbms_output.put_line('update cstm_function_userdef_fields set field_val_'||n||'= '||q(i.field_value)||' where function_id = '||q('GLDCHACT')||' and rec_key= '||q(l_gl||'~')||';');
end loop;
end;
/
@restoreset


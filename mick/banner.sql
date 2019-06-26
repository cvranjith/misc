set verify off
set serverout on size 10000
declare type t is table of varchar2(1000) index by binary_integer; q varchar2(10000) := '&text'; s varchar2(1); x t; y t;
procedure p (a varchar2, g out t)
is b varchar2(10000) := upper(a); begin
if b='A'    then g(1) :='   ##   ';g(2) :='  #  #  ';g(3) :=' #    # ';g(4) :=' ###### ';g(5) :=' #    # ';g(6) :=' #    # ';
elsif b='B' then g(1) :=' #####  ';g(2) :=' #    # ';g(3) :=' #####  ';g(4) :=' #    # ';g(5) :=' #    # ';g(6) :=' #####  ';
elsif b='C' then g(1) :='  ####  ';g(2) :=' #    # ';g(3) :=' #      ';g(4) :=' #      ';g(5) :=' #    # ';g(6) :='  ####  ';
elsif b='D' then g(1) :=' #####  ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #    # ';g(5) :=' #    # ';g(6) :=' #####  ';
elsif b='E' then g(1) :=' ###### ';g(2) :=' #      ';g(3) :=' #####  ';g(4) :=' #      ';g(5) :=' #      ';g(6) :=' ###### ';
elsif b='F' then g(1) :=' ###### ';g(2) :=' #      ';g(3) :=' #####  ';g(4) :=' #      ';g(5) :=' #      ';g(6) :=' #      ';
elsif b='G' then g(1) :='  ####  ';g(2) :=' #    # ';g(3) :=' #      ';g(4) :=' #  ### ';g(5) :=' #    # ';g(6) :='  ####  ';
elsif b='H' then g(1) :=' #    # ';g(2) :=' #    # ';g(3) :=' ###### ';g(4) :=' #    # ';g(5) :=' #    # ';g(6) :=' #    # ';
elsif b='I' then g(1) :='    #   ';g(2) :='    #   ';g(3) :='    #   ';g(4) :='    #   ';g(5) :='    #   ';g(6) :='    #   ';
elsif b='J' then g(1) :='      # ';g(2) :='      # ';g(3) :='      # ';g(4) :='      # ';g(5) :=' #    # ';g(6) :='  ####  ';
elsif b='K' then g(1) :=' #    # ';g(2) :=' #   #  ';g(3) :=' ####   ';g(4) :=' #  #   ';g(5) :=' #   #  ';g(6) :=' #    # ';
elsif b='L' then g(1) :='#       ';g(2) :='#       ';g(3) :='#       ';g(4) :='#       ';g(5) :='#       ';g(6) :='####### ';
elsif b='M' then g(1) :=' #    # ';g(2) :=' ##  ## ';g(3) :=' # ## # ';g(4) :=' #    # ';g(5) :=' #    # ';g(6) :=' #    # ';
elsif b='N' then g(1) :=' #    # ';g(2) :=' ##   # ';g(3) :=' # #  # ';g(4) :=' #  # # ';g(5) :=' #   ## ';g(6) :=' #    # ';
elsif b='O' then g(1) :='  ####  ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #    # ';g(5) :=' #    # ';g(6) :='  ####  ';
elsif b='P' then g(1) :=' #####  ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #####  ';g(5) :=' #      ';g(6) :=' #      ';
elsif b='Q' then g(1) :='  ####  ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #  # # ';g(5) :=' #   #  ';g(6) :='  ### # ';
elsif b='R' then g(1) :=' #####  ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #####  ';g(5) :=' #   #  ';g(6) :=' #    # ';
elsif b='S' then g(1) :='  ####  ';g(2) :=' #      ';g(3) :='  ####  ';g(4) :='      # ';g(5) :=' #    # ';g(6) :='  ####  ';
elsif b='T' then g(1) :='  ##### ';g(2) :='    #   ';g(3) :='    #   ';g(4) :='    #   ';g(5) :='    #   ';g(6) :='    #   ';
elsif b='U' then g(1) :=' #    # ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #    # ';g(5) :=' #    # ';g(6) :='  ####  ';
elsif b='V' then g(1) :=' #    # ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' #    # ';g(5) :='  #  #  ';g(6) :='   ##   ';
elsif b='W' then g(1) :=' #    # ';g(2) :=' #    # ';g(3) :=' #    # ';g(4) :=' # ## # ';g(5) :=' ##  ## ';g(6) :=' #    # ';
elsif b='X' then g(1) :=' #    # ';g(2) :='  #  #  ';g(3) :='   ##   ';g(4) :='   ##   ';g(5) :='  #  #  ';g(6) :=' #    # ';
elsif b='Y' then g(1) :='  #   # ';g(2) :='   # #  ';g(3) :='    #   ';g(4) :='    #   ';g(5) :='    #   ';g(6) :='    #   ';
elsif b='Z' then g(1) :=' ###### ';g(2) :='     #  ';g(3) :='    #   ';g(4) :='   #    ';g(5) :='  #     ';g(6) :=' ###### ';
/*
elsif b='1' then
elsif b='2' then
elsif b='3' then
elsif b='4' then
elsif b='5' then
elsif b='6' then
elsif b='7' then
elsif b='8' then
elsif b='9' then
elsif b='0' then
*/
else             g(1) :='        ';g(2) :='        ';g(3) :='        ';g(4) :='        ';g(5) :='        ';g(6) :='        ';end if;
end;
procedure l (w varchar2) is begin dbms_output.put_line(w);end;
begin
for i in 1..6 loop y(i) := '~'; end loop;
for m in 1..length(q) loop s := substr(q,m,1); p(s,x); for i in 1 .. 6 loop y(i) := y(i)||x(i); end loop; end loop;
l('~'); l('~');
for i in 1 .. 6 loop l(y(i)); end loop;
l('~'); l('~');
end;
/

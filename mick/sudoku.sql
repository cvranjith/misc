
undef c
set serverout on size 1000000 line 9999
declare
t  dbms_sql.varchar2_table;
t1 dbms_sql.varchar2_table;
d  dbms_sql.varchar2_table;
s  varchar2(1000);
n1 number;
m1 number;
b boolean;
b1 boolean;
procedure p(x varchar2)
is
n number;
begin
t(t.count+1) := x;
for i in 1..9
loop
n := substr(x,((2*i)-1),2);


t1(n) := t1(n)||lpad(t.count,2,'0');

end loop;
end;
procedure pr
is
x varchar2(1000);
b2 boolean := true;
begin
for i in 1..81
loop
if length(d(i)) > 1 then b2 := false; end if;
x := x||rpad( nvl(d(i),' '),9,' ')||' | ';
if mod(i,9) = 0
then
dbms_output.put_line(x);
x := null;
end if;
end loop;
if b2
then
dbms_output.put_line('Valid Solution!! Kudos');
end if;
end;

procedure put(x in number, y in number)
is
n number;
m number;
l number;
begin
--dbms_output.put_line('x = '||x||' y = '||y||' : '||t1(x));
d(x) := y;
for i in 1..3
loop
n := substr(t1(x), ((2*i)-1), 2);
--dbms_output.put_line('>>'||n||'>>'||t(n));
for j in 1..9
loop
m := substr(t(n), ((2*j)-1), 2);
--dbms_output.put_line('>>'||m||'>>'||d(m));
if m != x and length(d(m)) > 1
then
l := length(d(m));
d(m) := replace(d(m),y);

if l != length(d(m)) and length(d(m)) = 1
then
put(m, d(m)); --recursion!!
end if;
end if;
end loop;
end loop;
end;

begin
--s := '53  7    6  195    98    6 8   6   34  8 3  17   2   6 6    28    419  5    8  79';
s := ' 3   1     6    5 5     983 8   63 2    5    9 38   6 714     9 2    8     4   3 ';

for i in 1..81 loop t1(i) := null; d(i) := '123456789'; end loop;
p('010203040506070809');
p('101112131415161718');
p('192021222324252627');
p('282930313233343536');
p('373839404142434445');
p('464748495051525354');
p('555657585960616263');
p('646566676869707172');
p('737475767778798081');
p('011019283746556473');
p('021120293847566574');
p('031221303948576675');
p('041322314049586776');
p('051423324150596877');
p('061524334251606978');
p('071625344352617079');
p('081726354453627180');
p('091827364554637281');
p('010203101112192021');
p('040506131415222324');
p('070809161718252627');
p('282930373839464748');
p('313233404142495051');
p('343536434445525354');
p('555657646566737475');
p('585960676869767778');
p('616263707172798081');

--dbms_output.put_line(t.count);



--pr;

s := rpad(s,81,' ');
for i in 1..81
loop
--dbms_output.put_line(':'||substr(s,i,1)||':');

if substr(s,i,1) != ' '
then
	put(i, substr(s,i,1));
end if;
end loop;
pr;


for q in 1..50
loop
b1 := false;

for i in 1..81
--for i in 21..21
loop
	if length(d(i)) > 1
	then
		--dbms_output.put_line('==> '||i||'==>'||d(i));
		for j in 1..length(d(i))
		loop
			for k in 1..3
			loop
				b := true;
				n1 := substr(t1(i), ((2*k)-1), 2);
				--dbms_output.put_line('n1 = '||n1||':'||t(n1));
				for l in 1..9
				loop
					m1 := substr(t(n1), ((2*l)-1), 2);
					--dbms_output.put_line('m1/l = '||t(n1)||':'||l||':'||m1||':'||d(m1));
					if m1 != i
					then
						if instr(d(m1), substr(d(i),j,1)) > 0
						then
							--dbms_output.put_line('False');
							b := false;
							exit;
						end if;
					end if;
				end loop;
				if b
				then
					--dbms_output.put_line('==got '||i||' '||substr(d(i),j,1)||' : '||d(i));
					put(i, substr(d(i),j,1));
					b1 := true;
					exit;
				end if;
			end loop;
			if b1
			then
				exit;
			end if;
		end loop;
		if b1
		then
			exit;
		end if;
	end if;
end loop;
dbms_output.put_line('try '||q);
--pr;
if not b1
then
	dbms_output.put_line('No use in trying further');
	exit;
end if;
end loop;
pr;
end;
/


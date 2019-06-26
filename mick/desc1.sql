rem
rem 03/2001 SF ORDERED hint added
rem
--UNDEFINE 1
--ACCEPT 1 CHAR PROMPT 'Table ==> '
set linesize 999
set recsep off
column dummy noprint
column type format A15
column name format A20
column infos format A40 word_wrapped
break on col# on name on N on type
set verify off
select	/*+ORDERED*/
	c.col# dummy,
	c.name,
	decode(c.null$, 0, '', '*') N,
	decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(') 
		|| to_char(c.length)
		|| ')', 2, 	decode(c.precision#, 126, 'FLOAT', 'NUMBER' 
		|| decode(c.scale, NULL, '', '(' 
		|| to_char(nvl(c.precision#, (c.length - 3) * 2)) 
		|| decode(c.scale, 0, ')', ',' 
		|| to_char(c.scale) 
		|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
		|| to_char(c.length) 
		|| ') VARYING', 12, 'DATE', 23, 'RAW' 
		|| '(' 
		|| to_char(c.length) 
		|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
		|| to_char(c.length) || ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
		|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type, 
	substr(cm.comment$, 1, 1000) infos,
	0 dummy
from	sys.obj$ o,
		sys.user$ u,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot,
		sys.com$ cm
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and		o.name = upper(substr('&1', instr('&1', '.') + 1))
and		u.user# = o.owner#
and		o.obj# = c.obj#
and		c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		cm.obj# = o.obj#
and		cm.col# = c.col#
and		c.col# > 0 
--=========
union
--=========
select
	/*+ORDERED*/
	c.col#,
	c.name,
	decode(c.null$, 0, '', '*') N,
	decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(') 
		|| to_char(c.length)
		|| ')', 2, decode(c.precision#, 126, 'FLOAT', 'NUMBER'
		|| decode(c.scale, NULL, '', '(' 
		|| to_char(nvl(c.precision#, (c.length - 3) * 2)) 
		|| decode(c.scale, 0, ')', ',' 
		|| to_char(c.scale) 
		|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
		|| to_char(c.length) 
		|| ') VARYING', 12, 'DATE', 23, 'RAW' 
		|| '(' 
		|| to_char(c.length) 
		|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
		|| to_char(c.length) 
		|| ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
		|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type,
	'*** PK '
		|| to_char(cc.pos#) 
		|| '/' 
		|| to_char(cd.cols), 1 
from	sys.obj$ o,
		sys.user$ u,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot,
		sys.cdef$ cd,
		sys.ccol$ cc
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and		o.name = upper(substr('&1', instr('&1', '.') + 1))
and		u.user# = o.owner#
and		o.obj# = c.obj#
and		c.col# > 0
and		c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		cd.obj# = o.obj#
and		cd.type# = 2
and		cd.con# = cc.con#
and		cc.obj# = o.obj#
and		cc.col# = c.col#
--================
union
--================
select
	/*+ORDERED*/
	c.col#, 
	c.name,
	decode(c.null$, 0, '', '*') N,
	decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(')
		|| to_char(c.length)
		|| ')', 2, decode(c.precision#, 126, 'FLOAT', 'NUMBER'
		|| decode(c.scale, NULL, '', '(' 
		|| to_char(nvl(c.precision#, (c.length - 3) * 2)) 
		|| decode(c.scale, 0, ')', ',' 
		|| to_char(c.scale) 
		|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
		|| to_char(c.length) 
		|| ') VARYING', 12, 'DATE', 23, 'RAW' 
		|| '(' 
		|| to_char(c.length) 
		|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
		|| to_char(c.length) 
		|| ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
		|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type,
	'*** IDX '
		|| oi.name
		|| decode(bitand(i.property, 1), 0, ' ', '(U) ')
		|| to_char(ic.pos#)
		|| '/'
		|| to_char(i.cols),
	3
from	sys.obj$ o,
		sys.user$ u,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot,
		sys.ind$ i,
		sys.obj$ oi,
		sys.icol$ ic
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and		o.name = upper(substr('&1', instr('&1', '.') + 1))
and		u.user# = o.owner#
and		o.obj# = c.obj#
and		i.bo# = o.obj#
and		oi.obj# = i.obj#
and		ic.obj# = i.obj#
and		ic.bo# = i.bo#
and		ic.col# = c.col#
and		c.col# > 0
and		c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		not exists
			(
			select
				/*+ORDERED*/
				'x'
			from	sys.cdef$ cd,
					sys.ccol$ cc,
					sys.con$ co
			where	cc.obj# = c.obj#
			and		cc.col# = c.col#
			and		cc.con# = cd.con#
			and		co.con# = cd.con#
			and		co.name = oi.name
			and		cd.type# = 2
			)
--=================
union
--=================
select	/*+ORDERED*/
		c.col#,
		c.name,
		decode(c.null$, 0, '', '*') N,
		decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(') 
			|| to_char(c.length) 
			|| ')', 2, decode(c.precision#, 126, 'FLOAT', 'NUMBER' 
			|| decode(c.scale, NULL, '', '(' 
			|| to_char(nvl(c.precision#, (c.length - 3) * 2)) 
			|| decode(c.scale, 0, ')', ',' 
			|| to_char(c.scale) 
			|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
			|| to_char(c.length) 
			|| ') VARYING', 12, 'DATE', 23, 'RAW' 
			|| '(' 
			|| to_char(c.length) 
			|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
			|| to_char(c.length) 
			|| ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
			|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type,
		'*** IDX '
			|| oi.name
			|| '(C) '
			|| to_char(ic.pos#)
			|| '/'
			|| to_char(i.cols),
		3
from	sys.obj$ o,
		sys.user$ u,
		sys.tab$ t,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot,
		sys.ind$ i,
		sys.obj$ oi,
		sys.icol$ ic,
		sys.clu$ cl,
		sys.col$ clc
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and 	o.name = upper(substr('&1', instr('&1', '.') + 1))
and		u.user# = o.owner#
and 	o.obj# = c.obj#
and		c.col# > 0
and 	c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		o.obj# = t.obj#
and		t.bobj# = cl.obj#
and		clc.obj# = cl.obj#
and		clc.segcol# = c.segcol#
and		i.bo# = cl.obj#
and		oi.obj# = i.obj#
and		ic.obj# = i.obj#
and		ic.bo# = i.bo#
and		ic.col# = clc.col#
--=================
union
--=================
select	/*+ORDERED*/
		c.col#,
		c.name,
		decode(c.null$, 0, '', '*') N,
		decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(')
			|| to_char(c.length)
			|| ')', 2, decode(c.precision#, 126, 'FLOAT', 'NUMBER' 
			|| decode(c.scale, NULL, '', '(' 
			|| to_char(nvl(c.precision#, (c.length - 3) * 2)) 
			|| decode(c.scale, 0, ')', ',' 
			|| to_char(c.scale) 
			|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
			|| to_char(c.length) 
			|| ') VARYING', 12, 'DATE', 23, 'RAW' 
			|| '(' || to_char(c.length) 
			|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
			|| to_char(c.length) 
			|| ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
			|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type,
		' ',
		0
from	sys.obj$ o,
		sys.user$ u,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and		o.name = upper(substr('&1', instr('&1', '.') + 1))
and		u.user# = o.owner#
and		o.obj# = c.obj#
and		c.col# > 0
and		c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		not exists
	(
	select	/*+ORDERED*/
			'x'
	from	sys.icol$ ic
	where	ic.bo# = c.obj#
	and		ic.col# = c.col#
	--=================
	union
	--=================
	select	/*+ORDERED*/
			'x'
	from	sys.tab$ t,
			sys.clu$ cl,
			sys.col$ clc
	where	t.obj# = o.obj#
	and		t.bobj# = cl.obj#
	and		clc.obj# = cl.obj#
	and		clc.segcol# = c.segcol#
	--=================
	union
	--=================
	select	/*+ORDERED*/
			'x'
	from	sys.com$ cm
	where	cm.obj# = c.obj#
	and		cm.col# = c.col#
	)
--=================
union
--=================
select	/*+ORDERED*/
		c.col#,
		c.name,
		decode(c.null$, 0, '', '*') N, decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(') 
			|| to_char(c.length) 
			|| ')', 2, decode(c.precision#, 126, 'FLOAT', 'NUMBER' 
			|| decode(c.scale, NULL, '', '(' 
			|| to_char(nvl(c.precision#, (c.length - 3) * 2)) 
			|| decode(c.scale, 0, ')', ',' 
			|| to_char(c.scale) 
			|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
			|| to_char(c.length) 
			|| ') VARYING', 12, 'DATE', 23, 'RAW' 
			|| '(' 
			|| to_char(c.length) 
			|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
			|| to_char(c.length) 
			|| ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
			|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type,
		'*** FK --> '
			|| o2.name
			|| '(' || c2.name || ') ' 
			|| ltrim(to_char(cc1.pos#)) 
			|| '/' 
			|| ltrim(to_char(cd1.cols)) ,
		2
from	sys.obj$ o,
		sys.user$ u,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot,
		sys.cdef$ cd1,
		sys.ccol$ cc1,
		sys.ccol$ cc2,
		sys.obj$ o2,
		sys.col$ c2
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and 	o.name = upper(substr('&1', instr('&1', '.') + 1))
and		o.obj# = c.obj#
and 	c.col# > 0
and 	c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		cd1.obj# = o.obj#
and		cd1.con# = cc1.con#
and		cc1.obj# = c.obj#
and		cc1.col# = c.col#
and		cd1.type# = 4
and		cc2.con# = cd1.rcon#
and		cc2.obj# = cd1.robj#
and		cc2.obj# = o2.obj#
and		cc2.obj# = c2.obj#
and		cc2.col# = c2.col#
and		cc1.pos# = cc2.pos#
--=================
union
--=================
select	/*+ORDERED*/
		c.col#,
		c.name,
		decode(c.null$, 0, '', '*') N,
		decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2(', 'VARCHAR2(')
			|| to_char(c.length)
			|| ')', 2, decode(c.precision#, 126, 'FLOAT', 'NUMBER'
			|| decode(c.scale, NULL, '', '(' 
			|| to_char(nvl(c.precision#, (c.length - 3) * 2))
			|| decode(c.scale, 0, ')', ',' 
			|| to_char(c.scale) 
			|| ')'))), 8, 'LONG', 9, decode(c.charsetform, 2, 'NCHAR(', 'VARCHAR(') 
			|| to_char(c.length) 
			|| ') VARYING', 12, 'DATE', 23, 'RAW' 
			|| '(' 
			|| to_char(c.length) 
			|| ')', 24, 'LONG RAW', 69, 'ROWID', 96, decode(c.charsetform, 2, 'NCHAR(', 'CHAR(') 
			|| to_char(c.length) 
			|| ')', 105, 'MLSLABEL', 106, 'MLSLABEL', 111, ot.name 
			|| '(REF)', 112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'), 113, 'BLOB', 114, 'BFILE', 115, 'CFILE', 121, ot.name, 122, ot.name, 123, ot.name, to_char(c.type#)) type,
		'*** FK <-- '
			|| o2.name 
			|| '('
			|| c2.name 
			|| ') '
			|| ltrim(to_char(cc2.pos#)) 
			|| '/'
			|| ltrim(to_char(cd2.cols)) ,
		2
from	sys.obj$ o,
		sys.user$ u,
		sys.col$ c,
		sys.coltype$ ct,
		sys.obj$ ot,
		sys.cdef$ cd2,
		sys.ccol$ cc1,
		sys.ccol$ cc2,
		sys.obj$ o2,
		sys.col$ c2
where	u.name = decode(instr('&1', '.'), 0, user, upper(substr('&1', 1, instr('&1', '.') - 1)))
and		o.name = upper(substr('&1', instr('&1', '.') + 1))
and		cd2.robj# = o.obj#
and		cd2.rcon# = cc1.con#
and		cc1.obj# = o.obj#
and		cc1.col# = c.col#
and		o.obj# = c.obj#
and 	c.col# > 0
and		c.obj# = ct.obj# (+)
and		c.col# = ct.col# (+)
and		ct.toid = ot.oid$ (+)
and		cd2.type# = 4
and		cd2.obj# = o2.obj#
and		cc2.obj# = o2.obj#
and		cc2.con# = cd2.con#
and		cc2.obj# = c2.obj#
and		cc2.col# = c2.col#
and		cc1.pos# = cc2.pos#
order by	1,
			6
/
UNDEFINE 1

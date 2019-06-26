select * from p b where not exists (select 1 from tb_r a where r = b.rowid)
/

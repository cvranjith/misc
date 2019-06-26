create tablespace FCC datafile 'D:\ORACLE\ORADATA\ORACLE\FCC.DBF' size 1024 M
default storage (initial 1m next 1m pctincrease 0 maxextents unlimited);
create user FCC identified by FCC default tablespace FCC
temporary tablespace TEMP
quota unlimited on FCC;

create tablespace BRANCH datafile 'D:\ORACLE\ORADATA\ORACLE\BRANCH.DBF' size 512 M
default storage (initial 1m next 1m pctincrease 0 maxextents unlimited);
create user BRANCH identified by BRANCH default tablespace BRANCH
temporary tablespace TEMP
quota unlimited on BRANCH;

create tablespace FCAT datafile 'D:\ORACLE\ORADATA\ORACLE\FCAT.DBF' size 32 M
default storage (initial 1m next 1m pctincrease 0 maxextents unlimited);
create user FCAT identified by FCAT default tablespace FCAT
temporary tablespace TEMP
quota unlimited on FCAT;
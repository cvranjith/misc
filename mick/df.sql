
set pagesize 150
set linesize 132
column file_name format a60
select DF.Name File_Name, FS.Phyblkrd Blocks_Read, FS.Phyblkwrt Blocks_Written,
FS.Phyblkrd+FS.Phyblkwrt Total_IOs, status Status, (bytes/1024/1024) M_Bytes
from V$FILESTAT FS, V$DATAFILE DF
where DF.File#=FS.File#
order by FS.Phyblkrd+FS.Phyblkwrt desc;


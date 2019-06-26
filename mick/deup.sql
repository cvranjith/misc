select count(1) , upload_stat,batch_no,branch_code from detb_upload_detail group by upload_stat,branch_code, batch_no
/

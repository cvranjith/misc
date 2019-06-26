@define.env
spo &tools_dir./Commitment_Migration/logs/step12.log
Prompt Query for check to Line account Balance,Accrued amt and Status
Select Branch_Code,Cust_Ac_No,Ccy,Acy_Curr_Balance,Lcy_Curr_Balance,Acy_Accrued_Dr_Ic - Acy_Accrued_Cr_Ic Accr_Amt,Record_Stat From   Sttms_Cust_Account Where  Account_Type = 'L';
Prompt Accrual Adjustment entry Reconcilation 
Select 'Accrual reversal @ line Account'a, Ac_Branch,Ac_No,Sum(Lcy_Amount) From Actb_Daily_log where related_Account in (Select Alt_acc_No from Cltb_Account_Master where Loan_Type='C') and Event='MIGR' and Amount_tag='IACR' and DrCr_Ind='C'  and Nvl(Delete_stat,'X')<>'D' Group by Ac_Branch,Ac_No
Union 
Select 'Accrual entry @ Commitment Account'a ,Ac_Branch,Ac_No,Sum(Lcy_Amount) From Actb_Daily_log where related_Account in (Select Account_Number from Cltb_Account_Master where Loan_Type='C') and Event='MIGR' and Amount_tag='ACQD_INT_LIQD' and DrCr_Ind='C'  and Nvl(Delete_stat,'X')<>'D' Group by Ac_Branch,Ac_No;
Prompt Contigent Entries reconcilation
Select x.*,y.*,Nvl(x.Amount,0) - Nvl(y.Amount,0) Difference From   (Select Branch_Code ,Cust_Ac_No ,Ccy ,(Select Sum(Decode(Drcr_Ind, 'D', -nvl(Fcy_Amount, Lcy_Amount), Nvl(Fcy_Amount, Lcy_Amount))) From   Actb_Daily_Log Where  Related_Account = a.Cust_Ac_No And    Event = 'MIGR' And    Amount_Tag = 'LIMTOVAMT' And    Drcr_Ind = 'D' And    Nvl(Delete_Stat, 'X') <> 'D' And    Ac_Branch = a.Branch_Code) Amount From   Sttm_Cust_Account a Where  Account_Type = 'L') x ,(Select Branch_Code ,Alt_Acc_No ,Account_Number ,Currency ,(Select Sum(Decode(Drcr_Ind, 'D', -nvl(Fcy_Amount, Lcy_Amount), Nvl(Fcy_Amount, Lcy_Amount))) From   Actb_Daily_Log Where  Related_Account = b.Account_Number And    Event In ('DSBR', 'LINK', 'DLNK') And    Ac_No In (Select Account_Head From   Cltm_Product_Rth Where  Product_Code = Substr(b.Account_Number, 4, 4) And    Accounting_Role = 'FWDASSETOFF') And    Nvl(Delete_Stat, 'X') <> 'D') Amount From   Cltb_Account_Master b Where  Loan_Type = 'C') y Where  x.Branch_Code = y.Branch_Code And    x.Cust_Ac_No = y.Alt_Acc_No And    Nvl(Abs(x.Amount), 0) <> Nvl(Abs(y.Amount), 0) Order  By 2;
Prompt GL balance Checks 
Select a.* ,b.* ,Abs(Nvl(a.Bal, 0)) - Abs(Nvl(b.Bal, 0)) Diff From   (Select 'Commitment' Cl_Side  ,Ac_Branch ,Ac_No ,Sum(Decode(Drcr_Ind, 'D', -lcy_Amount, 'C', Lcy_Amount)) Bal From   Actb_Daily_Log Where  Event Not In ('CYPO') And    Related_Account In (Select Account_Number From   Cltb_Account_Master Where  Loan_Type = 'C') And    Nvl(Delete_Stat, 'X') <> 'D' Group  By Ac_Branch ,Ac_No) a ,(Select 'Line Account' Casa_Side ,Ac_Branch ,Ac_No ,Sum(Decode(Drcr_Ind, 'D', -lcy_Amount, 'C', Lcy_Amount)) Bal From   Actb_Daily_Log Where  Trn_ref_no like '%MIGR%' And    Nvl(Delete_Stat, 'X') <> 'D' Group  By Ac_Branch ,Ac_No) b
Where  a.Ac_Branch = b.Ac_Branch(+) And    a.Ac_No = b.Ac_No(+) And    Abs(Nvl(a.Bal, 0)) <> Abs(Nvl(b.Bal, 0)) Order  By a.Ac_Branch ,a.Ac_No;
spool off


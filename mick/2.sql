@define.env
spo &tools_dir./Commitment_Migration/logs/step11.log
Begin
    For Each_Branch In (Select *
                        From   Sttm_Branch
                        Where  Record_Stat = 'O'
                        And    Once_Auth = 'Y')
    Loop
        Global.Pr_Init(Pm_Branch => Each_Branch.Branch_Code, Pm_User => 'SYSTEM');
        Debug.Pr_Set_Async_Ref('CM_CLOSELINE' || Each_Branch.Branch_Code);
        Elpks_Commitment_Migration.Pr_Close_Line_Accounts(p_Branch => Global.Current_Branch, p_Line_Acc => Null);
    End Loop;
End;
/
spool off


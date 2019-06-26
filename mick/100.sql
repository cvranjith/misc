@define.env
spool &tools_dir./LD-CL/Contract_Migration/logs/post_mig_step3.log

Declare
    Cursor Cur_Prod Is
        Select Distinct Cl_Product
        From   Cstb_Ldcl_Prod_Mapping;
    --truncate table CLTM_PRODUCT_RTH;
    --i number;
    Perr_Code   Ertbs_Msgs.Err_Code%Type;
    Perr_Params Varchar2(500);
    --lprod    CLTMS_PRODUCT.PRODUCT_CODE%TYPE;
    Err Exception;
Begin
    Global.Pr_Init(Global.Head_Office, 'SYSTEM');
    Debug.Pr_Set_Async_Ref('CL_RESTOREPRODUCT');
    For l In Cur_Prod
    Loop
        --truncate table CLTM_PRODUCT_RTH;
        Delete From Cltm_Product_Rth
        Where  Product_Code = l.Cl_Product;
        Insert Into Cltm_Product_Rth
            (Product_Code
            ,Map_Type
            ,Accounting_Role
            ,Role_Type
            ,Account_Head
            ,Role_Desc
            ,Head_Desc)
            (Select Product_Code
                   ,Map_Type
                   ,Accounting_Role
                   ,Role_Type
                   ,Account_Head
                   ,Role_Desc
                   ,Head_Desc
             From   Cstm_Product_Rth_Bkup
             Where  Product_Code = l.Cl_Product);
    
        --Satish changes started for SITE#INTG#52
        Delete From Cltm_Product_Rth_Expr
        Where  Product_Code = l.Cl_Product;
        Insert Into Cltm_Product_Rth_Expr
            (Product_Code
            ,Accounting_Role
            ,EXPR_LINE
            ,Account_Head
            ,COND)
            (Select Product_Code
                   ,Accounting_Role
                   ,EXPR_LINE
                   ,Account_Head
                   ,COND
             From   Cstm_Product_Rth_Expr_Bkup
             Where  Product_Code = l.Cl_Product);
	--Satish chages ends for SITE#INTG#52
	--truncate table cltm_product_event_rules_entry;
        Delete From Cltm_Product_Event_Rules_Entry
        Where  Product_Code = l.Cl_Product;
        Insert Into Cltm_Product_Event_Rules_Entry
            (Product_Code
            ,Event_Code
            ,Act_Rule_No
            ,Transaction_Code
            ,Dr_Cr_Indicator
            ,Netting_Indicator
            ,Account_Role_Code
            ,Amt_Tag
            ,Role_Type
            ,Amount_Tag_Type
            ,Mis_Head
            ,Glmis_Update_Flag
            ,Reval_Required
            ,Reval_Profit_Gl
            ,Reval_Loss_Gl
            ,Reval_Rate_Code
            ,Reval_Txn_Code
            ,Mis_Spread
            ,Holiday_Treatment
            ,Resch_Bullet_Non_Due
            ,Resch_Repop
            ,Gaap_Indicator
            ,Bal_Chk_Batch
            ,Delinquency_Product
            ,Entry_Pair_No)
        
            Select Product_Code
                  ,Event_Code
                  ,Act_Rule_No
                  ,Transaction_Code
                  ,Dr_Cr_Indicator
                  ,Netting_Indicator
                  ,Account_Role_Code
                  ,Amt_Tag
                  ,Role_Type
                  ,Amount_Tag_Type
                  ,Mis_Head
                  ,Glmis_Update_Flag
                  ,Reval_Required
                  ,Reval_Profit_Gl
                  ,Reval_Loss_Gl
                  ,Reval_Rate_Code
                  ,Reval_Txn_Code
                  ,Mis_Spread
                  ,Holiday_Treatment
                  ,Resch_Bullet_Non_Due
                  ,Resch_Repop
                  ,Gaap_Indicator
                  ,Bal_Chk_Batch
                  ,Delinquency_Product
                  ,Entry_Pair_No
            From   Cstm_Prd_Evntrules_Entr_b
            Where  Product_Code = l.Cl_Product;
    
        --truncate table cltms_product_event_rules_adv;
        Delete From Cltms_Product_Event_Rules_Adv
        Where  Product_Code = l.Cl_Product;
        Insert Into Cltms_Product_Event_Rules_Adv
            (Product_Code
            ,Event_Code
            ,Adv_Rule_No
            ,Msg_Type
            ,Generation_Time
            ,Suppress
            ,Priority
            ,Chg_Reqd
            ,Format)
            Select Product_Code
                  ,Event_Code
                  ,Adv_Rule_No
                  ,Msg_Type
                  ,Generation_Time
                  ,Suppress
                  ,Priority
                  ,Chg_Reqd
                  ,Format
            From   Cstm_Prd_Evntrules_Adv_b
            Where  Product_Code = l.Cl_Product;
    
        --for L in cur_prod loop
        If Not Clpks_Prd_Rulegen.Fn_Create_Rules(l.Cl_Product, Perr_Code, Perr_Params)
        Then
            Debug.Pr_Debug('CL', 'error creating dynamic package fro product' || Perr_Code);
            Debug.Pr_Debug('CL', 'error ' || Perr_Params);
            Rollback;
            Raise Err;
        End If;
    End Loop;

    Commit;
Exception
    When Err Then
        Debug.Pr_Debug('CL', 'fAILED in this stub - Run Again! ' || Sqlerrm);
        Rollback;
    When Others Then
        Debug.Pr_Debug('CL', 'fAILED in this stub - Run Again! ' || Sqlerrm);
        Rollback;
End;
/
spool off


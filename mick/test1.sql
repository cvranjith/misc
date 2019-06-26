create view test1
as
SELECT C.UNITHOLDERID , c.cifnumber,
       (SELECT SUM(SUM(UnitsIn-UnitsOut)*B.PRICE)
       FROM UHBalLedgerTbl A, SUCCESSIONPRICETBL B
       WHERE
       A.UNITHOLDERID = C.UNITHOLDERID
       AND A.FUNDID = B.FUNDID
       AND TransactionDate <=
         (select FC_START_DATE - 1 from fcclive.sttm_fin_cycle where fin_cycle =
              (select current_cycle from fcclive.sttm_branch a, fcclive.sttm_bank b
                   where a.branch_code = b.ho_branch )
             )
       GROUP BY B.FUNDID,B.PRICE
       ) ClosingBalanceAmount
           FROM UNITHOLDERTBL C
           where C.AuthRejectStatus = 'A'
/

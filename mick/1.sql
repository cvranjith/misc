with bcs as
(
SELECT  bc.our_lc_ref
                                      FROM BCTB_CONTRACT_MASTER BC,
                                           CSTB_CONTRACT        CS
                                     WHERE BC.BCREFNO = CS.CONTRACT_REF_NO
                                       AND CS.CONTRACT_STATUS = 'A'
)
SELECT *
                             FROM CSTBS_CONTRACT A
                            WHERE A.MODULE_CODE = 'LC'
                              AND A.PRODUCT_TYPE IN ('E', 'I', 'S')
                              AND AUTH_STATUS = 'A' 
                              AND (A.CONTRACT_STATUS = 'A' OR
                                  (TRUNC(A.LATEST_EVENT_DATE, 'RRRR') =
                                  TRUNC(GLOBAL.APPLICATION_DATE, 'RRRR'))  OR
                                  EXISTS
                                   (SELECT 1
                                      FROM CSTBS_CONTRACT_EVENT_LOG B
                                     WHERE TRUNC(B.MAKER_DT_STAMP, 'RRRR') =
                                           TRUNC(GLOBAL.APPLICATION_DATE,
                                                 'RRRR')
                                       AND A.CONTRACT_REF_NO =
                                           B.CONTRACT_REF_NO) 
                                   OR a.contract_ref_no in
                                   (SELECT * 
                                      FROM bcs
                                       )
                                  )
                              AND A.CONTRACT_STATUS != 'H'
                              AND SUBSTR(CONTRACT_REF_NO, 4, 4) IN
                                  (SELECT PRODUCT_CODE
                                     FROM CSTM_PRODUCT
                                    WHERE PRODUCT_GROUP NOT LIKE 'G%')
/

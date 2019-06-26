SELECT SUM(UnitsIn-UnitsOut) Units, A.FundID, B.PRICE
FROM UHBalLedgerTbl A, SUCCESSIONPRICETBL B
WHERE
A.FUNDID = B.FUNDID
AND UnitholderID = '&UH' AND
TransactionDate <= '31-DEC-2001'
GROUP BY A.FundID, B.PRICE
/
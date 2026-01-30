SELECT
  T0."TransId",
  T0."Memo",
  T0."TaxDate",
  T1."ShortName",
  T1."ContraAct",
  T1."Credit",
  T1."FCCredit",
  T0."TransType",
  T1."Ref3Line"
FROM
  "OJDT" T0
  INNER JOIN "JDT1" T1 ON T0."TransId" = T1."TransId"
WHERE
  T0."TransType" = 30
  AND T1."ShortName" = 'PE10000-5'
  AND (
    T1."Account" = '101030302'
    OR T1."Account" = '201020103'
  )
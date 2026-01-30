SELECT
  T0."DocNum" AS "NumeroPago",
  T0."CardName",
  T0."DocDate" AS "FechaPago",
  T0."DocTotal" AS "Total USD",
  T0."DocTotalFC" AS "Total CLP",
  T0."Comments",
  T0."JrnlMemo",
  T0."BpAct",
  T2."AcctName",
  T1."DocEntry" AS "DocInternoFactura",
  T1."SumApplied" AS "MontoAplicado",
  T3."DocTotal" AS "MontoFactura",
  T3."DocTotalFC" AS "MontoFactura CLP",
  T3."FolioNum" AS "FolioFactura"
FROM
  "SBO_CNAUSDPROD"."OVPM" T0
  INNER JOIN "SBO_CNAUSDPROD"."OACT" T2 ON T0."BpAct" = T2."AcctCode"
  LEFT JOIN "SBO_CNAUSDPROD"."VPM2" T1 ON T0."DocEntry" = T1."DocNum"
  LEFT JOIN "SBO_CNAUSDPROD"."OPCH" T3 ON T1."DocEntry" = T3."DocEntry"
WHERE
  T0."CardCode" = 'PE10000-5';
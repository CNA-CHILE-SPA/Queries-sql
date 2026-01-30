SELECT
  T0."DocNum" as "Transferencia de Stock",
  T0."DocEntry",
  T0."FolioPref",
  T0."FolioNum",
  T0."DocDate",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."FromWhsCod",
  T1."WhsCode",
  T2."InvntryUom",
  T0."Comments",
  T3."U_NAME"
FROM
  OWTR T0
  INNER JOIN WTR1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN OITM T2 ON T2."ItemCode" = T1."ItemCode"
  INNER JOIN OUSR T3 ON T0."UserSign" = T3."USERID"
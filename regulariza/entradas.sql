SELECT
  T0."BPLId",
  T0."DocDate",
  T0."DocNum",
  T0."CANCELED",
  T0."CardCode",
  T0."CardName",
  T0."NumAtCard",
  T0."Comments",
  T1."LineNum",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."Price",
  T1."Currency",
  T1."LineTotal",
  T1."TotalFrgn",
  T1."WhsCode",
  T2."U_NAME"
FROM
  OPDN T0
  INNER JOIN PDN1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN OUSR T2 ON T0."UserSign" = T2."USERID"
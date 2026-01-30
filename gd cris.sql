SELECT
  T1."DocEntry",
  T0."FolioNum",
  T0."CardCode",
  T0."CardName",
  T0."DocStatus",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  COALESCE(T2."Code", T1."ItemCode") AS "Código componente",
  COALESCE(T3."ItemName", T1."Dscription") AS "Descripción del artículo",
  COALESCE(T2."Quantity", 1) AS "Cantidad base Lista materiales",
  T1."Quantity" * COALESCE(T2."Quantity", 1) AS "Cantidad total Componente",
  T1."WhsCode",
  T0."DocDate",
  T0."NumAtCard"
FROM
  ODLN T0
  INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
  LEFT JOIN ITT1 T2 ON T1."ItemCode" = T2."Father"
  LEFT JOIN OITM T3 ON T2."Code" = T3."ItemCode"
ORDER BY
  T1."DocEntry",
  T1."ItemCode";
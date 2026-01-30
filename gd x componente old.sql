SELECT
  T1."DocEntry",
  T0."FolioNum",
  T0."CardCode",
  T0."CardName",
  T0."DocStatus",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T2."Code" AS "CÃ³digo componente",
  T3."ItemName",
  T2."Quantity" AS "Cantidad base Lista materiales",
  (T1."Quantity" * T2."Quantity") AS "Cantidad total Componente",
  T1."WhsCode",
  T0."DocDate",
  T0."NumAtCard" -- T0."U_SEI_FOREF",
  -- T0."U_SEI_FEREF" AS "Fecha Rereferencia 1"
FROM
  ODLN T0
  INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
  LEFT JOIN ITT1 T2 ON T1."ItemCode" = T2."Father"
  LEFT JOIN OITM T3 ON T2."Code" = T3."ItemCode"
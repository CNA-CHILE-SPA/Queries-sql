SELECT
  T0."DocEntry",
  T0."DocNum",
  T0."FolioNum",
  T0."CardCode",
  T0."CardName",
  T0."DocDate",
  SUM(T1."Quantity") AS "TotalCantidad"
FROM
  ODLN T0
  INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
GROUP BY
  T0."DocEntry",
  T0."DocNum",
  T0."FolioNum",
  T0."CardCode",
  T0."CardName",
  T0."DocDate"
ORDER BY
  T0."DocEntry";
SELECT
  T0."DocNum",
  T0."FolioNum",
  T1."ItemCode",
  T1."Quantity",
  T1."PriceBefDi",
  T0."DocRate"
FROM
  OINV T0
  INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
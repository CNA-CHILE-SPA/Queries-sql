SELECT
  T1."DocEntry",
  T0."DocNum",
  T0."FolioNum",
  T0."DocDate",
  T0."CardCode",
  T0."CardName",
  T1."LineNum",
  T1."Quantity",
  T0."U_EXX_FE_FOLIODB" as "Factura asociada",
  CASE
    T1."NoInvtryMv"
    WHEN 'Y' THEN 'Sin Movimiento'
    WHEN 'N' THEN 'Con Movimiento'
  End AS "Movimiento Inventario"
FROM
  ORIN T0
  INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
  T0."DocType" = 'I'
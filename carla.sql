SELECT
  'CNA' AS "Empresa",
  T0."DocNum" AS "Número de Factura",
  T0."FolioNum" AS "Folio SII",
  T0."DocDate" AS "Fecha de Factura",
  T0."DocDueDate" AS "Fecha de Vencimiento",
  T0."CardCode" AS "Código Cliente",
  T0."CardName" AS "Nombre Cliente",
  T0."DocTotal" as "Total Factura USD",
  T0."DocTotalFC" as "Total Factura CLP",
  T0."PaidFC" as "Total Pagado CLP",
  T0."DocTotalFC" - T0."PaidFC" as "Total Pendiente CLP"
FROM
  OPCH T0
WHERE
  T0."CardCode" like 'PN%'
  AND (T0."DocTotal" - T0."PaidToDate") > 0
  AND (
    T0."DocNum" LIKE '3%'
    or T0."DocNum" LIKE '1%'
  )
UNION
ALL
SELECT
  'FA' AS "Empresa",
  T0."DocNum" AS "Número de Factura",
  T0."FolioNum" AS "Folio SII",
  T0."DocDate" AS "Fecha de Factura",
  T0."DocDueDate" AS "Fecha de Vencimiento",
  T0."CardCode" AS "Código Cliente",
  T0."CardName" AS "Nombre Cliente",
  T0."DocTotal" as "Total Factura USD",
  T0."DocTotalFC" as "Total Factura CLP",
  T0."PaidFC" as "Total Pagado CLP",
  T0."DocTotalFC" - T0."PaidFC" as "Total Pendiente CLP"
FROM
  OPCH T0
WHERE
  T0."CardCode" like 'PN%'
  AND (T0."DocTotal" - T0."PaidToDate") > 0
  AND (
    T0."DocNum" LIKE '4%'
    or T0."DocNum" LIKE '2%'
  )
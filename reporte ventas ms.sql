SELECT
  T0."DocNum",
  CASE
    T0."DocSubType"
    WHEN 'IX' THEN 'FACTURA EXPORTACION'
    WHEN 'DN' THEN 'Nota de Débito'
    WHEN 'IE' THEN 'FACTURA EXENTA'
    WHEN '--' THEN CASE
      T0."isIns"
      WHEN 'Y' THEN 'Factura de Reserva'
      WHEN 'N' THEN 'Facturas de Deudores'
    END
  END AS "Tipo",
  T0."FolioPref" as "Indicador",
  T0."FolioNum" AS "Folio SII",
  T0."TaxDate" AS " Fecha Emisión",
  T0."DocDueDate" AS " Fecha Vencimiento",
  T0."NumAtCard" AS "Nro OC",
  T9."PymntGroup" AS " Condición de Pago",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T2."LicTradNum" as "Rut",
  T3."SlpName" As "Vendedor",
  -- agregar total en usd y en fc
  T0."DocCur" as "Moneda Documento",
  T0."DocTotal" as "Total en USD",
  T0."DocTotalSy" as "Total en CLP",
  T0."Installmnt" as "Cantidad de Cuotas",
  T6."InstlmntID" "Cuota N°",
  T6."DueDate" as "Fecha Vencimiento Cuota",
  T6."InsTotalFC" as "Total Cuota"
FROM
  OINV T0
  INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
  INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
  INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
  INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
  INNER JOIN INV6 T6 ON T0."DocEntry" = T6."DocEntry"
WHERE
  T0."CANCELED" = 'N'
  AND YEAR(T0."DocDate") > 2022
  AND (
    T0."DocNum" LIKE '3%'
    or T0."DocNum" like '1%'
  )
UNION
ALL
SELECT
  T0."DocNum",
  'Notas de Credito Articulos',
  T0."FolioPref" as "Indicador",
  T0."FolioNum" AS "Folio SII",
  T0."TaxDate" AS " Fecha Emisión",
  T0."DocDueDate" AS " Fecha Vencimiento",
  T0."NumAtCard" AS "Nro OC",
  T9."PymntGroup" AS " Condición de Pago",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T2."LicTradNum" as "Rut",
  T3."SlpName" As "Vendedor",
  -- agregar total en usd y en fc
  T0."DocCur" as "Moneda Documento",
  - T0."DocTotal" as "Total en USD",
  - T0."DocTotalSy" as "Total en CLP",
  NULL AS "Cantidad de Cuotas",
  -- No aplica a las notas de crédito
  NULL AS "Cuota N°",
  -- No aplica a las notas de crédito
  NULL AS "Fecha Vencimiento Cuota",
  -- No aplica a las notas de crédito
  NULL AS "Total Cuota" -- No aplica a las notas de crédito
FROM
  ORIN T0
  INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
  INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
  INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
  INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
WHERE
  T0."CANCELED" = 'N'
  AND T0."DocType" = 'I'
  AND YEAR(T0."DocDate") > 2022
  AND (
    T0."DocNum" LIKE '3%'
    or T0."DocNum" like '1%'
  )
UNION
ALL
SELECT
  T0."DocNum",
  'Notas de Credito Servicio',
  T0."FolioPref" as "Indicador",
  T0."FolioNum" AS "Folio SII",
  T0."TaxDate" AS " Fecha Emisión",
  T0."DocDueDate" AS " Fecha Vencimiento",
  T0."NumAtCard" AS "Nro OC",
  T9."PymntGroup" AS " Condición de Pago",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T2."LicTradNum" as "Rut",
  T3."SlpName" As "Vendedor",
  -- agregar total en usd y en fc
  T0."DocCur" as "Moneda Documento",
  - T0."DocTotal" as "Total en USD",
  - T0."DocTotalSy" as "Total en CLP",
  NULL AS "Cantidad de Cuotas",
  -- No aplica a las notas de crédito
  NULL AS "Cuota N°",
  -- No aplica a las notas de crédito
  NULL AS "Fecha Vencimiento Cuota",
  -- No aplica a las notas de crédito
  NULL AS "Total Cuota" -- No aplica a las notas de crédito
FROM
  ORIN T0
  INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
  INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
  INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
  INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
WHERE
  T0."CANCELED" = 'N'
  AND T0."DocType" = 'S'
  AND YEAR(T0."DocDate") > 2022
  AND (
    T0."DocNum" LIKE '3%'
    or T0."DocNum" like '1%'
  )
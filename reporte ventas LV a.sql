SELECT
  T0."FolioNum" AS "Folio SII",
  T0."FolioPref" as "Indicador",
  T0."U_EXX_FE_FOLIODB",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T0."TaxDate" AS " Fecha Emisión",
  T0."DocDueDate" AS " Fecha Vencimiento",
  NULL AS "Nueva fecha",
  NULL AS "PLAZO",
  T6."InstlmntID" "Cuota N°",
  T0."DocTotal" as "Total en USD",
  T0."DocCur" as "Moneda",
  T0."DocTotalSy" as "Total en CLP",
  T6."InsTotalFC" as "Total Cuota",
  NULL AS "NC",
  NULL AS "Pago",
  NULL AS "CH CARTERA",
  NULL AS "MONTO",
  NULL AS "DIAS VENCIDOS",
  NULL AS "NUEVOS VENCIDOS",
  NULL AS "RANGO",
  T3."SlpName" As "Vendedor"
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
    T0."DocNum" LIKE '4%'
    or T0."DocNum" like '2%'
  )
UNION
ALL
SELECT
  T0."FolioNum" AS "Folio SII",
  T0."FolioPref" as "Indicador",
  T0."U_EXX_FE_FOLIODB",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T0."TaxDate" AS " Fecha Emisión",
  T0."DocDueDate" AS " Fecha Vencimiento",
  NULL AS "Nueva fecha",
  NULL AS "PLAZO",
  NULL AS "Cuota N°",
  - T0."DocTotal" as "Total en USD",
  T0."DocCur" as "Moneda",
  - T0."DocTotalSy" as "Total en CLP",
  NULL AS "Total Cuota",
  NULL AS "NC",
  NULL AS "Pago",
  NULL AS "CH CARTERA",
  NULL AS "MONTO",
  NULL AS "DIAS VENCIDOS",
  NULL AS "NUEVOS VENCIDOS",
  NULL AS "RANGO",
  T3."SlpName" As "Vendedor"
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
    T0."DocNum" LIKE '4%'
    or T0."DocNum" like '2%'
  )
UNION
ALL
SELECT
  T0."FolioNum" AS "Folio SII",
  T0."FolioPref" as "Indicador",
  T0."U_EXX_FE_FOLIODB",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T0."TaxDate" AS " Fecha Emisión",
  T0."DocDueDate" AS " Fecha Vencimiento",
  NULL AS "Nueva fecha",
  NULL AS "PLAZO",
  NULL AS "Cuota N°",
  - T0."DocTotal" as "Total en USD",
  T0."DocCur" as "Moneda",
  - T0."DocTotalSy" as "Total en CLP",
  NULL AS "Total Cuota",
  NULL AS "NC",
  NULL AS "Pago",
  NULL AS "CH CARTERA",
  NULL AS "MONTO",
  NULL AS "DIAS VENCIDOS",
  NULL AS "NUEVOS VENCIDOS",
  NULL AS "RANGO",
  T3."SlpName" As "Vendedor"
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
    T0."DocNum" LIKE '4%'
    or T0."DocNum" like '2%'
  )
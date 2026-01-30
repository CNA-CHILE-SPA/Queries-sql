SELECT
  T0."FolioNum" AS "Folio SII",
  NULL AS "CUENTA",
  T0."FolioPref" as "Indicador",
  T0."U_EXX_FE_FOLIODB",
  NULL AS "N° DOC REF",
  T0."CardCode" AS "Codigo Cliente",
  T2."LicTradNum" as "RUT Cliente",
  T0."CardName" AS "Razón Social",
  T0."TaxDate" AS " Fecha Emisión",
  NULL as "PLAZO",
  T0."DocDueDate" AS " Fecha Vencimiento",
  T0."Installmnt" as "Cantidad de Cuotas",
  T0."DocTotal" as "Total en USD",
  T0."DocCur" as "Moneda",
  T0."DocTotalSy" as "Total en CLP",
  T6."InsTotalFC" as "Total Cuota",
  NULL as "1",
  NULL as "2",
  NULL as "3",
  NULL as "4",
  NULL as "5",
  Null as "6",
  NULL as "7",
  NULL as "8",
  NULL as "9",
  NULL as "10",
  NULL as "11",
  NULL as "12",
  NULL as "13",
  NULL as "14",
  NULL as "15",
  Null as "16",
  NULL as "17",
  NULL as "18",
  NULL as "19",
  NULL as "120",
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
  NULL AS "CUENTA",
  T0."FolioPref" as "Indicador",
  T0."U_EXX_FE_FOLIODB",
  NULL AS "N° DOC REF",
  T0."CardCode" AS "Codigo Cliente",
  T2."LicTradNum" as "RUT Cliente",
  T0."CardName" AS "Razón Social",
  T0."TaxDate" AS " Fecha Emisión",
  NULL as "PLAZO",
  T0."DocDueDate" AS " Fecha Vencimiento",
  NULL as "Cantidad de Cuotas",
  - T0."DocTotal" as "Total en USD",
  T0."DocCur" as "Moneda",
  - T0."DocTotalSy" as "Total en CLP",
  NULL AS "Total Cuota",
  NULL as "1",
  NULL as "2",
  NULL as "3",
  NULL as "4",
  NULL as "5",
  Null as "6",
  NULL as "7",
  NULL as "8",
  NULL as "9",
  NULL as "10",
  NULL as "11",
  NULL as "12",
  NULL as "13",
  NULL as "14",
  NULL as "15",
  Null as "16",
  NULL as "17",
  NULL as "18",
  NULL as "19",
  NULL as "20",
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
  NULL AS "CUENTA",
  T0."FolioPref" as "Indicador",
  T0."U_EXX_FE_FOLIODB",
  NULL AS "N° DOC REF",
  T0."CardCode" AS "Codigo Cliente",
  T2."LicTradNum" as "RUT Cliente",
  T0."CardName" AS "Razón Social",
  T0."TaxDate" AS " Fecha Emisión",
  NULL as "PLAZO",
  T0."DocDueDate" AS " Fecha Vencimiento",
  NULL as "Cantidad de Cuotas",
  - T0."DocTotal" as "Total en USD",
  T0."DocCur" as "Moneda",
  - T0."DocTotalSy" as "Total en CLP",
  NULL AS "Total Cuota",
  NULL as "1",
  NULL as "2",
  NULL as "3",
  NULL as "4",
  NULL as "5",
  Null as "6",
  NULL as "7",
  NULL as "8",
  NULL as "9",
  NULL as "10",
  NULL as "11",
  NULL as "12",
  NULL as "13",
  NULL as "14",
  NULL as "15",
  Null as "16",
  NULL as "17",
  NULL as "18",
  NULL as "19",
  NULL as "20",
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
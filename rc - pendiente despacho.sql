SELECT
  'Orden de Venta',
  T0."DocNum" AS "Nº Documento",
  T0."NumAtCard",
  T6."SlpName",
  T0."DocDate",
  T0."CardCode",
  T0."CardName",
  T2."CreditLine",
  T2."Balance" AS "Saldo de Cuenta",
  T8."PymntGroup",
  T1."ItemCode",
  T1."Dscription",
  T1."Currency",
  T1."Price" as "Precio Venta",
  T7."AvgPrice",
  T1."WhsCode",
  COALESCE(T4."Code", T1."ItemCode") AS "Código del Componente",
  COALESCE(T5."ItemName", T1."Dscription") AS "Nombre del Componente",
  --  T5."ItemName",
  T1."Quantity" AS " Cantidad Total Documento",
  T1."OpenQty" AS "Cantidad Pendiente Documento",
  T4."Quantity" As "Cantidad Base Lista de Materiales",
  CASE
    WHEN T4."Quantity" IS NULL THEN T1."OpenQty"
    ELSE COALESCE(T4."Quantity", 0) * T1."OpenQty"
  END AS "Cantidad Total del Componente"
FROM
  ORDR T0
  INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
  LEFT JOIN OITT T3 ON T1."ItemCode" = T3."Code"
  LEFT JOIN ITT1 T4 ON T3."Code" = T4."Father"
  LEFT JOIN OITM T5 ON T4."Code" = T5."ItemCode"
  INNER JOIN OSLP T6 ON T0."SlpCode" = T6."SlpCode"
  INNER JOIN OITW T7 ON T1."ItemCode" = T7."ItemCode"
  and T1."WhsCode" = T7."WhsCode"
  INNER JOIN OCTG T8 ON T2."GroupNum" = T8."GroupNum"
WHERE
  T0."DocStatus" = 'O'
  AND T0."CANCELED" <> 'Y'
  AND (T1."Quantity" - T1."OpenQty") >= 0 --AND YEAR(T0."DocDate")>2023
    AND T0."DocDate" <= [%0]
UNION
ALL
SELECT
  'Factura de Reserva',
  T0."DocNum" AS "Nº Documento",
  T0."NumAtCard",
  T6."SlpName",
  T0."DocDate",
  T0."CardCode",
  T0."CardName",
  T2."CreditLine",
  T2."Balance" AS "Saldo de Cuenta",
  T8."PymntGroup",
  T1."ItemCode",
  T1."Dscription",
  T1."Currency",
  T1."Price" as "Precio Venta",
  T7."AvgPrice",
  T1."WhsCode",
  COALESCE(T4."Code", T1."ItemCode") AS "Código del Componente",
  COALESCE(T5."ItemName", T1."Dscription") AS "Nombre del Componente",
  --  T5."ItemName",
  -- T4."Code" AS "Código del Componente",
  -- T5."ItemName" as "Nombre del Componente",
  T1."Quantity" AS " Cantidad Total Documento",
  T1."OpenQty",
  T4."Quantity" As "Cantidad Base Lista de Materiales",
  CASE
    WHEN T4."Quantity" IS NULL THEN T1."OpenQty"
    ELSE COALESCE(T4."Quantity", 0) * T1."OpenQty"
  END AS "Cantidad Total del Componente"
FROM
  OINV T0
  INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
  LEFT JOIN OITT T3 ON T1."ItemCode" = T3."Code"
  LEFT JOIN ITT1 T4 ON T3."Code" = T4."Father"
  LEFT JOIN OITM T5 ON T4."Code" = T5."ItemCode"
  INNER JOIN OSLP T6 ON T0."SlpCode" = T6."SlpCode"
  INNER JOIN OITW T7 ON T1."ItemCode" = T7."ItemCode"
  and T1."WhsCode" = T7."WhsCode"
  INNER JOIN OCTG T8 ON T2."GroupNum" = T8."GroupNum"
WHERE
  T0."CANCELED" <> 'Y'
  AND T0."isIns" = 'Y'
  AND (T1."Quantity" - T1."OpenQty") >= 0 --AND YEAR(T0."DocDate")>2023
  AND T0."DocDate" <= [%0]
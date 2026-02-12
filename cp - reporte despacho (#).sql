SELECT
    'Orden de Venta',
    T0."DocNum" AS "Nº Documento",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
        ELSE 'Otra Sucursal'
    END AS "Sucursal",
    T0."NumAtCard",
    T6."SlpName",
    T0."DocDate",
    T0."TaxDate",
    T0."CreateDate",
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
    COALESCE(T5."ItemName", T1."Dscription") AS "ItemName",
    T1."Quantity" AS "Cantidad Total Documento",
    T1."OpenQty" AS "Cantidad Pendiente Documento",
    COALESCE(T4."Quantity", 1) AS "Cantidad Base Lista de Materiales",
    T1."OpenQty" * COALESCE(T4."Quantity", 1) AS "Cantidad Total del Componente"
FROM
    ORDR T0
    INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
    LEFT JOIN OITT T3 ON T1."ItemCode" = T3."Code"
    LEFT JOIN ITT1 T4 ON T3."Code" = T4."Father"
    LEFT JOIN OITM T5 ON T4."Code" = T5."ItemCode"
    INNER JOIN OSLP T6 ON T0."SlpCode" = T6."SlpCode"
    INNER JOIN OITW T7 ON T1."ItemCode" = T7."ItemCode"
    AND T1."WhsCode" = T7."WhsCode"
    INNER JOIN OCTG T8 ON T2."GroupNum" = T8."GroupNum"
WHERE
    T0."DocStatus" = 'O'
    AND T0."CANCELED" <> 'Y'
    AND (T1."Quantity" - T1."OpenQty") >= 0
UNION
ALL
SELECT
    'Factura de Reserva',
    T0."DocNum" AS "Nº Documento",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
        ELSE 'Otra Sucursal'
    END AS "Sucursal",
    T0."NumAtCard",
    T6."SlpName",
    T0."DocDate",
    T0."TaxDate",
    T0."CreateDate",
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
    COALESCE(T5."ItemName", T1."Dscription") AS "ItemName",
    T1."Quantity" AS "Cantidad Total Documento",
    T1."OpenQty",
    COALESCE(T4."Quantity", 1) AS "Cantidad Base Lista de Materiales",
    T1."OpenQty" * COALESCE(T4."Quantity", 1) AS "Cantidad Total del Componente"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
    LEFT JOIN OITT T3 ON T1."ItemCode" = T3."Code"
    LEFT JOIN ITT1 T4 ON T3."Code" = T4."Father"
    LEFT JOIN OITM T5 ON T4."Code" = T5."ItemCode"
    INNER JOIN OSLP T6 ON T0."SlpCode" = T6."SlpCode"
    INNER JOIN OITW T7 ON T1."ItemCode" = T7."ItemCode"
    AND T1."WhsCode" = T7."WhsCode"
    INNER JOIN OCTG T8 ON T2."GroupNum" = T8."GroupNum"
WHERE
    T0."CANCELED" <> 'Y'
    AND T0."isIns" = 'Y'
    AND (T1."Quantity" - T1."OpenQty") >= 0
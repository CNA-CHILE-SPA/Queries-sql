-- Definir el CTE para combinar Ordenes de Venta y Facturas de Reserva
WITH CombinedDocuments AS (
    -- Parte de Ordenes de Venta
    SELECT
        'Orden de Venta' AS "Tipo de Documento",
        CASE
            T0."BPLId"
            WHEN 1 THEN 'CNA'
            WHEN 2 THEN 'FA'
            ELSE 'Otra Sucursal'
        END AS "Sucursal",
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
        T1."Currency",
        T1."Price" AS "Precio Venta",
        T7."AvgPrice",
        T1."Dscription",
        T1."ItemCode" as "Código",
        T1."WhsCode",
        T1."Quantity" AS "Cantidad Total Documento",
        T1."OpenQty" AS "Cantidad Pendiente Documento"
    FROM
        ORDR T0
        INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
        INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
        INNER JOIN OSLP T6 ON T0."SlpCode" = T6."SlpCode"
        INNER JOIN OITW T7 ON T1."ItemCode" = T7."ItemCode"
        AND T1."WhsCode" = T7."WhsCode"
        INNER JOIN OCTG T8 ON T2."GroupNum" = T8."GroupNum"
    WHERE
        T0."DocStatus" = 'O'
        AND T0."CANCELED" <> 'Y'
        AND (T1."Quantity" - T1."OpenQty") >= 0
    UNION
    ALL -- Parte de Facturas de Reserva
    SELECT
        'Factura de Reserva' AS "Tipo de Documento",
        CASE
            T0."BPLId"
            WHEN 1 THEN 'CNA'
            WHEN 2 THEN 'FA'
            ELSE 'Otra Sucursal'
        END AS "Sucursal",
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
        T1."Currency",
        T1."Price" AS "Precio Venta",
        T7."AvgPrice",
        T1."Dscription",
        T1."ItemCode" as "Código",
        T1."WhsCode",
        T1."Quantity" AS "Cantidad Total Documento",
        T1."OpenQty" AS "Cantidad Pendiente Documento"
    FROM
        OINV T0
        INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
        INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
        INNER JOIN OSLP T6 ON T0."SlpCode" = T6."SlpCode"
        INNER JOIN OITW T7 ON T1."ItemCode" = T7."ItemCode"
        AND T1."WhsCode" = T7."WhsCode"
        INNER JOIN OCTG T8 ON T2."GroupNum" = T8."GroupNum"
    WHERE
        T0."CANCELED" <> 'Y'
        AND T0."isIns" = 'Y'
        AND (T1."Quantity" - T1."OpenQty") >= 0
) -- Consulta Principal para Agrupar los Documentos
SELECT
    -- "Tipo de Flujo",
    "Sucursal",
    "Tipo de Documento",
    "Nº Documento",
    "NumAtCard" as "N° OV",
    "SlpName" as "Vendedor Asociado",
    "DocDate" AS "Fecha Contabilización",
    "CardCode" AS "Código Cliente",
    "CardName",
    "CreditLine",
    "Saldo de Cuenta",
    "PymntGroup",
    "Código",
    "Dscription",
    COUNT("ItemCode") AS "Cantidad de Ítems",
    SUM("Precio Venta" * "Cantidad Total Documento") AS "Total Precio Venta",
    AVG("Precio Venta") AS "Precio Venta Promedio",
    SUM("Cantidad Total Documento") AS "Cantidad Total Documento",
    SUM("Cantidad Pendiente Documento") AS "Cantidad Pendiente Documento",
    AVG("AvgPrice") AS "Precio Promedio Almacen"
FROM
    CombinedDocuments
GROUP BY
    -- "Tipo de Flujo",
    "Sucursal",
    "Tipo de Documento",
    "Nº Documento",
    "NumAtCard",
    "SlpName",
    "DocDate",
    "CardCode",
    "CardName",
    "CreditLine",
    "Saldo de Cuenta",
    "PymntGroup",
    "Dscription",
    "Código"
ORDER BY
    "Nº Documento";
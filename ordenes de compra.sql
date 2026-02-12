SELECT
    'Ordenes de Compra',
    T0."DocNum",
    CASE
        T0."DocStatus"
        WHEN 'C' THEN 'Cerrado'
        WHEN 'O' THEN 'Abierto'
    END AS "Estado Documento",
    T0."NumAtCard" AS "Numero Oc",
    CASE
        T2."LineStatus"
        WHEN 'C' THEN 'Cerrado'
        WHEN 'O' THEN 'Abierto'
    END AS "Estado Linea",
    T0."TaxDate",
    T0."DocDate",
    T0."CreateDate",
    T0."CardCode",
    T1."CardName",
    T2."ItemCode" as "Codigo",
    T2."Dscription" as "Descripcion",
    T0."LicTradNum" AS "RUT",
    T2."ItemCode",
    T2."Dscription" AS " Descripción",
    T2."WhsCode" AS "Bodega",
    T2."Quantity" AS " Cantidad",
    (T2."Quantity" - T2."OpenQty") AS "Cantidad Recepcionada",
    T2."OpenQty" AS "Cantidad Restante",
    T2."PriceBefDi" as "Precio Antes Dcto",
    T2."DiscPrcnt" as "% Desc",
    T2."Price" as "Precio",
    T2."LineTotal",
    T2."LineVat" as "IVA",
    T2."TaxCode" as "Tipo Impuesto",
    T0."DocTotal" as "Total",
    T2."AcctCode" as "Cuenta Contable",
    T2."OcrCode" as "Area Negocio"
FROM
    OPOR T0
    INNER JOIN OCRD T1 ON T0."CardCode" = T1."CardCode"
    INNER JOIN POR1 T2 ON T0."DocEntry" = T2."DocEntry"
UNION
ALL
SELECT
    'Facturas de Reserva no despachadas',
    T0."DocNum",
    CASE
        T0."DocStatus"
        WHEN 'C' THEN 'Cerrado'
        WHEN 'O' THEN 'Abierto'
    END AS "Estado Documento",
    T0."NumAtCard" AS "Numero Oc",
    CASE
        T2."LineStatus"
        WHEN 'C' THEN 'Cerrado'
        WHEN 'O' THEN 'Abierto'
    END AS "Estado Linea",
    T0."TaxDate",
    T0."DocDate",
    T0."CreateDate",
    T0."CardCode",
    T2."ItemCode" as "Codigo",
    T2."Dscription" as "Descripcion",
    T1."CardName",
    T0."LicTradNum" AS "RUT",
    T2."ItemCode",
    T2."Dscription" AS " Descripción",
    T2."WhsCode" AS "Bodega",
    T2."Quantity",
    (T2."Quantity" - T2."OpenQty") AS "Cantidad Recepcionada",
    T2."OpenQty",
    T2."PriceBefDi" as "Precio Antes Dcto",
    T2."DiscPrcnt" as "% Desc",
    T2."Price" as "Precio",
    T2."LineTotal",
    T2."LineVat" as "IVA",
    T2."TaxCode" as "Tipo Impuesto",
    T0."DocTotal" as "Total",
    T2."AcctCode" as "Cuenta Contable",
    T2."OcrCode" as "Area Negocio"
FROM
    OPCH T0
    INNER JOIN OCRD T1 ON T0."CardCode" = T1."CardCode"
    INNER JOIN PCH1 T2 ON T0."DocEntry" = T2."DocEntry"
WHERE
    T0."isIns" = 'Y'
    AND T2."LineStatus" = 'O'
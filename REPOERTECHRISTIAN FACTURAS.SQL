--- FACTURAS --
SELECT
    T0."DocEntry",
    CASE
        T0."DocSubType"
        WHEN 'IX' THEN 'FACTURA EXPORTACION'
        WHEN 'DM' THEN 'Nota de Débito'
        WHEN 'IE' THEN 'FACTURA EXENTA'
        WHEN '--' THEN CASE
            T0."isIns"
            WHEN 'Y' THEN 'Factura de Reserva'
            WHEN 'N' THEN 'Facturas de Deudores'
        END
    END AS "Tipo",
    T0."DocNum",
    CASE
        WHEN T0."CardCode" LIKE 'PN%' THEN 'Proveedor Nacional'
        WHEN T0."CardCode" LIKE 'PE%' THEN 'Proveedor Extranjero'
        ELSE 'Otro'
    END AS "Tipo Cliente",
    T0."CardCode" AS "Codigo Cliente",
    T0."CardName" AS "Razón Social",
    T4."LicTradNum" AS "RUT Cliente",
    T0."NumAtCard" AS "Número OV",
    T0."DocDate" AS "Fecha Contabilización",
    T0."DocDueDate" AS "Fecha Vencimiento",
    T0."TaxDate" AS "Fecha Documento",
    T0."FolioPref" AS "Prefijo",
    T0."FolioNum" AS "Folio SII",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Emisor",
    T0."DocCur" AS "Moneda",
    T0."DocTotalSy" AS "Total Documento CLP",
    T1."ItemCode" AS "Código Producto",
    T1."Dscription" AS "Descripción",
    T1."Quantity" AS "Cantidad",
    T0."Comments" AS "Comentarios"
FROM
    OPCH T0
    LEFT JOIN PCH1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OCRD T4 ON T0."CardCode" = T4."CardCode"




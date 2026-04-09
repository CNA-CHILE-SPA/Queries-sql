SELECT
    T0."DocEntry",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Sucursal",
    T0."DocNum",
    T0."FolioNum",
    T0."DocDate",
    T0."CardCode",
    T0."CardName",
    CASE
        T0."U_MOTIVO_NCND"
        WHEN '1' THEN 'CNA - Anula NC'
        WHEN '2' THEN 'CNA - Anula negocio con dev.'
        WHEN '3' THEN 'CNA - Anula negocio por no entrega'
        WHEN '4' THEN 'CNA - Anula pdte. Despacho'
        WHEN '5' THEN 'CNA - Área Comercial'
        WHEN '6' THEN 'CNA - Dcto. Comercial'
        WHEN '7' THEN 'CNA - Dcto. Pronto pago'
        WHEN '8' THEN 'CNA - Dev. Con reposición'
        WHEN '9' THEN 'CNA - Dev. Parcial'
        WHEN '10' THEN 'CNA - Diferencia T/C'
        WHEN '11' THEN 'CNA - Digitación Factura'
        WHEN '12' THEN 'CNA - Digitación GD'
        WHEN '13' THEN 'CNA - Digitación OV'
        WHEN '14' THEN 'CNA - Informa T/C día emisión'
        WHEN '15' THEN 'CNA - Merma'
        WHEN '16' THEN 'CNA - Modifica Info. SN'
        WHEN '17' THEN 'CNA - Rechazo de Factura'
        WHEN '18' THEN 'FA - Producto defectuoso'
        WHEN '19' THEN 'FA - Merma'
        WHEN '20' THEN 'FA - Falta de stock'
        WHEN '21' THEN 'FA - Atraso en despacho'
        WHEN '22' THEN 'FA - Producto rechazado'
        WHEN '23' THEN 'FA – Anulación negocio'
        WHEN '24' THEN 'FA – Error dpto. logística'
        WHEN '25' THEN 'FA - Error comercial'
        WHEN '26' THEN 'FA – Factura rechazada'
        WHEN '27' THEN 'FA – Error dpto facturación'
        WHEN '28' THEN 'FA - Administrativa'
        ELSE 'Sin motivo'
    END AS "Motivo",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T1."Price",
    T1."LineTotal" AS "Monto Neto Línea",
    T1."WhsCode",
    T0."DocCur",
    T0."DocRate",
    T0."DocTotal" AS "Total Documento",
FROM
    SBO_CNA_CHILE.ORIN T0
    INNER JOIN SBO_CNA_CHILE.RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."CANCELED" = 'N'
ORDER BY
    T0."DocDate",
    T0."DocNum";


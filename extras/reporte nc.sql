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
        WHEN '1' THEN 'Anula negocio con dev.'
        WHEN '2' THEN 'Anula por no entrega'
        WHEN '3' THEN 'Anula NC/ND'
        WHEN '4' THEN 'Anula pdte. despacho'
        WHEN '5' THEN 'Anula X motivo personal'
        WHEN '6' THEN 'Dcto. pronto pago'
        WHEN '7' THEN 'Dev. parcial'
        WHEN '8' THEN 'Dev. con reposicion'
        WHEN '9' THEN 'Dif precio/ Dcto. comercial'
        WHEN '10' THEN 'Diferencia T/C'
        WHEN '11' THEN 'Error en factura'
        WHEN '12' THEN 'Informa T/C dia emision'
        WHEN '13' THEN 'Interes por mora'
        WHEN '14' THEN 'Merma'
        WHEN '15' THEN 'Modifica rut/ dir./ giro'
        WHEN '16' THEN 'FA - LOGISTICA'
        WHEN '17' THEN 'FA - ERROR FACTURA'
        WHEN '18' THEN 'FA - GESTION'
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
    T0."DocTotal" AS "Total Documento"
FROM
    ORIN T0
    INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."CANCELED" = 'N'
ORDER BY
    T0."DocDate",
    T0."DocNum";
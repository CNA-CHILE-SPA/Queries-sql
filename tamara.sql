SELECT
    T0."DocEntry",
    T0."DocNum",
    T0."CardCode",
    T0."CardName",
    T0."NumAtCard",
    T0."DocDate",
    T0."DocDueDate",
    T0."FolioNum",
    CASE
        T0."isIns"
        WHEN 'Y' THEN 'Factura de Reserva'
        WHEN 'N' THEN 'Facturas de Deudores'
    END AS "Tipo",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T0."DocTotalSy"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
WHERE
    T3."SlpName" = 'Tamara Lopez'
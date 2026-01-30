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
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T1."Price",
    T1."TotalSumSy" AS "Monto Neto Línea",
    T1."WhsCode",
    T0."DocCur",
    T0."DocRate",
    T0."DocTotalSy" AS "Total Documento"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."CANCELED" = 'N'
ORDER BY
    T0."DocDate",
    T0."DocNum";
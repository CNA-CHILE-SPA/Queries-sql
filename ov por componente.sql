SELECT
    T0."DocNum",
    T0."DocDate",
    T0."TaxDate",
    T0."CreateDate",
    T0."NumAtCard",
    T0."CANCELED",
    T0."DocStatus",
    T0."DocDueDate",
    T0."CardCode",
    T0."CardName",
    T0."DocTotal",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity" AS "Cantidad ordenada",
    T1."Price",
    T1."LineTotal" AS "Total neto",
    COALESCE(T2."Code", T1."ItemCode") AS "Código componente",
    COALESCE(T3."ItemName", T1."Dscription") AS "Descripción del componente",
    COALESCE(T2."Quantity", 1) AS "Cantidad base Lista materiales",
    CASE
        WHEN T2."Code" IS NULL THEN T1."Quantity"
        ELSE T1."Quantity" * T2."Quantity"
    END AS "Cantidad total Componente",
    OSLP."SlpName" AS "Vendedor"
FROM
    ORDR T0
    INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN ITT1 T2 ON T1."ItemCode" = T2."Father"
    LEFT JOIN OITM T3 ON T2."Code" = T3."ItemCode"
    LEFT JOIN OSLP ON T0."SlpCode" = OSLP."SlpCode"
ORDER BY
    T0."DocDate" DESC;
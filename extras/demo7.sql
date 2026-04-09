SELECT
    T0."DocNum",
    T0."DocDate",
    T0."NumAtCard",
    T0."DocCur",
    T1."ItemCode",
    T1."Quantity",
    T1."WhsCode"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
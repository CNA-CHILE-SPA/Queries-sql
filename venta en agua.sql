SELECT
    T0."DocEntry",
    T0."DocNum",
    T0."CardCode",
    T0."CardName",
    T0."DocDate",
    T0."DocDueDate",
    T0."FolioPref",
    T0."FolioNum",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T1."WhsCode",
    T0."DocTotal",
    T3."FolioNum" AS "NC Asociada",
    T3."DocTotal" AS "Monto NC"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN RIN1 T2 ON T1."DocEntry" = T2."BaseEntry"
    AND T1."LineNum" = T2."BaseLine"
    AND T2."BaseType" = 13
    LEFT JOIN ORIN T3 ON T2."DocEntry" = T3."DocEntry"
WHERE
    T1."WhsCode" = 'CNA_AGUA'
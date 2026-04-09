SELECT
    T0."DocEntry",
    T0."DocNum",
    T0."CardCode",
    T0."CardName",
    T0."DocDate",
    T0."DocDueDate",
    T0."TaxDate",
    T0."FolioPref",
    T0."FolioNum",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T1."WhsCode"
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."BPLId" = 1
    AND T0."CardCode" = 'CN77038897-K'
    AND NOT EXISTS (
        SELECT
            1
        FROM
            OPDN T2
        WHERE
            T2."BPLId" = 2
            AND T2."FolioNum" = T0."FolioNum"
    )
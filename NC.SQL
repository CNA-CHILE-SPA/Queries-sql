SELECT
    T0."DocNum",
    T1."DocEntry",
    T0."FolioNum",
    T1."LineNum",
    T1."NoInvtryMv",
    T1."ItemCode",
    T1."Quantity"
FROM
    ORIN T0
    INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."DocType" = 'I'
SELECT
    T0."DocNum",
    T0."FolioNum",
    T1."DocEntry",
    T1."BaseRef",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T1."WhsCode",
    T2."U_NAME"
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OUSR T2 ON T0."UserSign" = T2."USERID"
WHERE
    T1."BaseRef" = ''
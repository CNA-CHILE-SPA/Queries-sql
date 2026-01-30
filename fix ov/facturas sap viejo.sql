SELECT
    T0."DocEntry",
    T0."DocNum",
    T0."FolioNum",
    T0."NumAtCard" as "OC",
    T0."CardCode",
    T0."CardName",
    T0."DocDate",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T1."OpenQty",
    T0."DocCur",
    T0."DocTotalSy"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."DocSubType" = '--'
    AND T0."isIns" = 'Y'
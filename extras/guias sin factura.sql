SELECT
    T0."DocEntry",
    T0."DocNum" AS "Primario Entrega",
    T0."FolioNum",
    T0."CardCode",
    T0."CardName",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T0."DocDate",
    T0."NumAtCard",
    T0."Comments",
    T0."DocTotalSy",
    T1."BaseEntry"
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T1."BaseEntry" IS NULL
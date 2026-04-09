SELECT
    T0."DocEntry",
    T0."DocNum",
    T0."FolioNum",
    T0."CardCode",
    T0."CardName",
    T0."DocDate",
    T0."DocDueDate",
    T0."DocTotal" AS "Total Documento",
    T0."DocTotalSy" AS "Total Documento CLP"
FROM
    SBO_CNA_CHILE.OINV T0
WHERE
    T0."CardCode" = 'CN 77038897-K'
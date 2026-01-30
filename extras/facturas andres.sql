SELECT
    F."DocNum",
    F."CardCode",
    F."CardName",
    F."FolioNum"
FROM
    OINV F
WHERE
    F."isIns" = 'Y';
SELECT
    T0."DocEntry",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Sucursal",
    T0."DocNum",
    T0."FolioNum",
    T0."DocDate",
    T0."U_EXX_FE_TDBSII",
    T0."U_EXX_FE_FOLIODB",
    T0."U_EXX_FE_FECHADB",
    T0."VatSum" AS "MontoIVA",
    T0."DocTotal" AS "MontoTotal",
    DAYS_BETWEEN(T0."DocDate", T0."U_EXX_FE_FECHADB") AS "DiasEntreFechas"
FROM
    SBO_CNA_CHILE.ORIN T0
    INNER JOIN SBO_CNA_CHILE.RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."CANCELED" = 'N'
ORDER BY
    T0."DocDate",
    T0."DocNum";


SELECT DATEDIFF(DAY, $[$179.U_EXX_FE_FECHADB.0.1177], $[$179.10.0.1]) FROM DUMMY;
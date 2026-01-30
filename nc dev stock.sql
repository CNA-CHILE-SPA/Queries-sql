SELECT DISTINCT
    T0."DocEntry",
    T0."DocNum",
    T0."DocDate",
    T0."CardCode",
    T0."CardName"
FROM ORIN T0
INNER JOIN OINM T1
    ON T1."TransType" = 14      -- Nota de crédito
   AND T1."CreatedBy" = T0."DocEntry"
WHERE T0."CANCELED" = 'N';

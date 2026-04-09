SELECT
    D."DocEntry",
    D."DocNum",
    D."BaseEntry",
    D."BaseType"
FROM
    OWDD T0
    INNER JOIN ODRF D ON T0."DraftEntry" = D."DocEntry"
    INNER JOIN DRF1 T1 ON D."DocEntry" = T1."DocEntry"
WHERE
    T1."BaseRef" = '1005382'
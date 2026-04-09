SELECT
    T0."NumAtCard" as "N ° OC",
    T0."DocDate" as "Fecha Emisión",
    T0."FolioNum",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T0."Comments",
    CASE
        WHEN T0."isIns" = 'Y' THEN 'Reserva'
        ELSE 'Deudor'
    END AS "Flujo"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
WHERE
    T2."LicTradNum" = '80576800-2' --Mavar
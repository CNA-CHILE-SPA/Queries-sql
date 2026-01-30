SELECT
    T0."DocNum",
    T3."DocNum" as "Primario Entrega Asociada",
    T3."FolioNum" AS "Folio Entrega Asociada",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity"
FROM
    ORIN T0
    INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN ODLN T3 ON T1."ActBaseNum" = T3."DocNum"
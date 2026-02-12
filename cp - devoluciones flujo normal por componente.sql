SELECT
    T0."DocEntry" AS "Numero interno",
    T0."DocDate" AS "Fecha transaccion",
    T0."TaxDate",
    T0."CreateDate",
    T1."ItemCode" AS "Codigo padre",
    T1."Quantity" AS "Cantidad padre",
    T4."Code" AS "Codigo insumo",
    T5."ItemName" AS "Nombre insumo",
    T4."Quantity" * T1."Quantity" AS "Cantidad insumo",
    T2."WhsCode" AS "Bodega Origen",
    T3."FolioNum" AS "Folio Guia Origen"
FROM
    ORDN T0
    INNER JOIN RDN1 T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN DLN1 T2 ON T1."BaseEntry" = T2."DocEntry"
    AND T1."BaseType" = 15
    AND T1."BaseLine" = T2."LineNum"
    INNER JOIN ODLN T3 ON T2."DocEntry" = T3."DocEntry"
    INNER JOIN ITT1 T4 ON T4."Father" = T1."ItemCode"
    INNER JOIN OITM T5 ON T5."ItemCode" = T4."Code"
WHERE
    T3."FolioNum" IS NOT NULL
    AND T3."FolioNum" <> 0;

-- Sin folios vacíos
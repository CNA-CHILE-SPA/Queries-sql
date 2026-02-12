SELECT
    T0."DocNum" AS "Numero NC",
    T0."DocDate" AS "Fecha transaccion",
    T0."TaxDate",
    T0."CreateDate",
    T3."DocNum" AS "Primario Entrega Asociada",
    T3."FolioNum" AS "Folio Entrega Asociada",
    T1."ItemCode" AS "Codigo padre",
    T1."Dscription" AS "Descripcion padre",
    T1."Quantity" AS "Cantidad padre",
    T4."Code" AS "Codigo insumo",
    T5."ItemName" AS "Nombre insumo",
    T4."Quantity" * T1."Quantity" AS "Cantidad insumo",
    T2."WhsCode" AS "Bodega Origen"
FROM
    ORIN T0
    INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN ODLN T3 ON T1."ActBaseNum" = T3."DocNum"
    INNER JOIN DLN1 T2 ON T2."DocEntry" = T3."DocEntry"
    AND T2."ItemCode" = T1."ItemCode"
    INNER JOIN ITT1 T4 ON T4."Father" = T1."ItemCode"
    INNER JOIN OITM T5 ON T5."ItemCode" = T4."Code"
WHERE
    T3."FolioNum" IS NOT NULL
    AND T3."FolioNum" <> 0;

-- Sin folios vacíos
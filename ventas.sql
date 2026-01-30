SELECT
    Case
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Empresa",
    T0."DocNum" AS "Número de Factura",
    T0."CardCode" AS "Código Cliente",
    T0."CardName" AS "Nombre Cliente",
    T0."DocDate" AS "Fecha de Factura",
    T0."DocDueDate" AS "Fecha de Vencimiento",
    T0."DocTotalSy" AS "Total Factura",
    T1."ItemCode" AS "Código Ítem",
    T1."Dscription" AS "Descripción Ítem",
    T1."Quantity" AS "Cantidad",
    T2."InvntryUom" AS "Unidad de Medida",
    T1."WhsCode" AS "Bodega"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OITM T2 ON T1."ItemCode" = T2."ItemCode"
WHERE
    T0."DocSubType" = '--'
    AND T0."DocType" = 'I'
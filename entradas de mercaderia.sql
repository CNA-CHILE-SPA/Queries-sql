SELECT
    T0."DocNum" AS "N° Primario",
    T0."DocEntry" AS "N° Documento",
    T0."DocDate" AS "Fecha Documento",
    T0."TaxDate",
    T0."CreateDate",
    T0."DocDueDate" AS "Fecha Vencimiento",
    T0."CardCode" AS "Código Proveedor",
    T0."CardName" AS "Nombre Proveedor",
    T1."ItemCode" AS "Código Artículo",
    T1."Dscription" AS "Descripción Artículo",
    T1."Quantity" AS "Cantidad",
    T1."Price" AS "Precio Unitario",
    T1."LineTotal" AS "Total Línea",
    T1."WhsCode" AS "Código Bodega",
    OWHS."WhsName" AS "Nombre Bodega",
    T0."Comments" AS "Comentarios"
FROM
    OPDN T0
    INNER JOIN PDN1 T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN OWHS ON T1."WhsCode" = OWHS."WhsCode"
WHERE
    T0."CANCELED" = 'N'
ORDER BY
    T0."DocDate" DESC,
    T0."DocEntry" ASC;
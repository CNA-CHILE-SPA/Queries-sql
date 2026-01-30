SELECT
    F."DocNum"      AS "Nº Entrega",
    F."DocDate"     AS "Fecha Entrega",
    F."DocDueDate"  AS "Fecha Vencimiento",
    F."TaxDate"     AS "Fecha Impuesto",
    F."CardCode"    AS "Código Cliente",
    F."NumAtCard"   AS "Nº Orden Compra",
    F."DocCur"      AS "Moneda Documento",
    F."Comments"    AS "Comentarios",
    F."FolioPref"   AS "Prefijo Folio",
    F."FolioNum"    AS "Número Folio",
    D."LineNum"     AS "Número Línea",
    D."ItemCode"    AS "Código Producto",
    D."Dscription"  AS "Descripción Producto",
    D."Quantity"    AS "Cantidad",
    D."Currency"    AS "Moneda Línea",
    D."PriceBefDi"  AS "Precio Unitario",
    D."WhsCode"     AS "Código Bodega"
FROM
    ODLN F
    INNER JOIN DLN1 D ON F."DocEntry" = D."DocEntry"
ORDER BY
    F."DocNum", D."LineNum";

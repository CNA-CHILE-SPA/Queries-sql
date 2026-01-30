SELECT
    F."DocNum" AS "Numero primario",
    F."DocDate" AS "Fecha ",
    F."DocDueDate" AS "Fecha Vencimiento",
    F."TaxDate" AS "Fecha Impuesto",
    F."CardCode" AS "Código Cliente",
    F."NumAtCard" AS "Nº Orden Compra",
    F."Comments" AS "Comentarios",
    D."LineNum" AS "Número Línea",
    D."ItemCode" AS "Código Producto",
    D."Quantity" AS "Cantidad",
    D."Currency" AS "Moneda Linea",
    D."PriceBefDi" AS "Precio Unitario",
    D."WhsCode" AS "Nombre Bodega Destino",
    F."DocTotal" as "Total Documento",
    F."DocCur" AS "Moneda"
FROM
    OPOR F
    INNER JOIN POR1 D ON F."DocEntry" = D."DocEntry"
WHERE
    F."DocStatus" = 'O'
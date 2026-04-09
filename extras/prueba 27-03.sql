SELECT
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
        ELSE 'Otra Sucursal'
    END AS "Sucursal",
    T0."DocNum" AS "Numero Factura",
    T0."DocEntry" AS "Entrada Documento",
    T0."DocType" AS "Tipo Documento",
    T0."DocDate" AS "Fecha Factura",
    T0."DocDueDate" AS "Fecha Vencimiento",
    T0."TaxDate" AS "Fecha Impuesto",
    T0."CardCode" AS "Código Cliente",
    T0."CardName" AS "Nombre Cliente",
    T0."DocCur" AS "Moneda",
    T0."DocTotal" AS "Total Documento",
    T1."LineNum" AS "Número Línea",
    T1."ItemCode" AS "Código Artículo",
    T1."Quantity" AS "Cantidad",
    T1."UomCode" AS "Unidad Medida",
    T1."DiscPrcnt" AS "Descuento %",
    T1."LineTotal" AS "Total Línea",
    T1."VatSum" AS "Impuesto Línea",
    T1."WhsCode" AS "Almacén"
FROM
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    -- Filtro por mes de febrero 2026
    MONTH(T0."DocDate") = 2
    AND YEAR(T0."DocDate") = 2026 -- Excluir documentos cancelados (opcional, descomenta si lo necesitas)
    -- AND T0."Cancelled" = "N"
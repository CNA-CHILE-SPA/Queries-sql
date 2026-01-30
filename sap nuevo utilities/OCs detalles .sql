SELECT
  F."DocNum" AS "Numero Factura",
  D."LineNum" AS "Número Línea",
  D."ItemCode" AS "Código Producto",
  D."Quantity" AS "Cantidad",
  D."Currency" AS "Moneda",
  D."PriceBefDi" AS "Precio Unitario",
  D."WhsCode" AS "Nombre Bodega"
FROM
  OPOR F
  INNER JOIN POR1 D ON F."DocEntry" = D."DocEntry"
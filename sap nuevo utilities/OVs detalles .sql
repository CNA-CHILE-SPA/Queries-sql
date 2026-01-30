SELECT
  F."DocNum" AS "Numero Factura",
  D."LineNum" AS "Número Línea",
  D."ItemCode" AS "Código Producto",
  D."Currency" AS "Moneda",
  D."Quantity" AS "Cantidad",
  D."PriceBefDi" AS "Precio Unitario",
  D."WhsCode" AS "Nombre Bodega"
FROM
  ORDR F
  INNER JOIN RDR1 D ON F."DocEntry" = D."DocEntry"

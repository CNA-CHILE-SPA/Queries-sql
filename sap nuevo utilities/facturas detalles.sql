SELECT
  F."DocNum" AS "Numero Factura",
  D."LineNum" AS "Número Línea",
  D."ItemCode" AS "Código Producto",
  D."OpenQty" AS "Cantidad",
  D."Currency" AS "Moneda",
  D."PriceBefDi" AS "Precio Unitario",
  D."WhsCode" AS "Nombre Bodega"
FROM
  OPCH F
  INNER JOIN PCH1 D ON F."DocEntry" = D."DocEntry"
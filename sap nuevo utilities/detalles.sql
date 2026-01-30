SELECT
  F."DocNum" AS "Nro Factura",
  I."LineNum" AS "Nro Linea",
  I."ItemCode" AS "Código Artículo",
  I."OpenQty" AS "Cantidad",
  I."Currency" AS "Moneda",
  I."Price" AS "Precio",
  I."WhsCode" AS "Código Almacén"
FROM
  ODLN Factura
  INNER JOIN DLN1 I ON Factura."DocEntry" = I."DocEntry"
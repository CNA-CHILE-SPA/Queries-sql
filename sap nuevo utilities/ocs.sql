SELECT
  P."DocNum" AS "Numero documento",
  P."NumAtCard" AS "Nº Orden Compra",
  P."CardCode" AS "Codigo cliente",
  P."CardName" AS "Nombre cliente",
  D."ItemCode" AS "Codigo producto",
  D."Dscription" AS "Descripcion producto",
  D."Quantity" AS "Cantidad",
  D."OpenQty" AS "Cantidad pendiente"
FROM
  ORDR P
  INNER JOIN RDR1 D ON P."DocEntry" = T."DocEntry"
WHERE
  D."OpenQty" > 0